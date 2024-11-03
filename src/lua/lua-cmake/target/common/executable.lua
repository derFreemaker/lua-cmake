local utils = require("lua-cmake.utils")
local set = require("lua-cmake.utils.set")
local target_options = require("lua-cmake.target.options")

---@class lua-cmake.target.common.executable.config.create
---@field name string
---@field srcs string[] | nil
---@field hdrs string[] | nil
---@field deps string[] | nil
---@field win32 boolean | nil
---@field macosx_bundle boolean | nil
---@field exclude_from_all boolean | nil
---@field options lua-cmake.target.options.create | nil

---@class lua-cmake.target.common.executable.config
---@field name string
---@field srcs lua-cmake.utils.set<string>
---@field hdrs lua-cmake.utils.set<string>
---@field deps lua-cmake.utils.set<string>
---@field win32 boolean | nil
---@field macosx_bundle boolean | nil
---@field exclude_from_all boolean | nil
---@field options lua-cmake.target.options

local kind = "lua-cmake.target.cxx.executable"
---@class lua-cmake.target.common.executable : object
---@field config lua-cmake.target.common.executable.config
---@overload fun(config: lua-cmake.target.common.executable.config.create) : lua-cmake.target.common.executable
local executable = {}

---@private
---@param config lua-cmake.target.common.executable.config.create
function executable:__init(config)
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.config = config

    if self.config.hdrs then
        cmake.path_resolver.resolve_paths_implace(self.config.hdrs)
    end
    self.config.hdrs = set(self.config.hdrs)

    if self.config.srcs then
        cmake.path_resolver.resolve_paths_implace(self.config.srcs)
    end
    self.config.srcs = set(self.config.srcs)

    if not self.config.options then
        ---@diagnostic disable-next-line: missing-fields
        self.config.options = {}
    end

    if self.config.options.precompile_headers then
        for index, hdr_group in ipairs(self.config.options.precompile_headers) do
            if type(hdr_group) == "table" then
                cmake.path_resolver.resolve_paths_implace(hdr_group)
            else
                ---@cast hdr_group string
                self.config.options.precompile_headers[index] = cmake.path_resolver.resolve_path(hdr_group)
            end
        end
    end
    self.config.options.precompile_headers = set(self.config.options.precompile_headers)

    self.config.options.link_libraries = set(self.config.options.link_libraries)
    self.config.deps = set(self.config.deps)

    cmake.registry.add_entry({
        get_name = function()
            return self.config.name
        end,

        add_hdrs = function(hdrs)
            self.config.hdrs:add_multiple(hdrs)
        end,
        add_srcs = function(srcs)
            self.config.srcs:add_multiple(srcs)
        end,
        add_links = function(links)
            self.config.options.link_libraries:add_multiple(links)
        end,

        get_deps = function()
            return self.config.deps:get()
        end,
    })

    cmake.generator.add_action({
        kind = kind,
        ---@param context lua-cmake.target.common.executable.config
        func = function(builder, context)
            local name = utils.make_name_cmake_conform(context.name)
            builder:append_line("add_executable(", name)

            if context.win32 then
                builder:append_indent()
                    :append_line("WIN32_EXECUTABLE")
            end

            if context.macosx_bundle then
                builder:append_indent()
                    :append_line("MACOSX_BUNDLE")
            end

            if context.exclude_from_all then
                builder:append_indent()
                    :append_line("EXCLUDE_FROM_ALL")
            end

            for _, hdr in ipairs(context.hdrs:get()) do
                builder:append_indent()
                    :append_line("\"", hdr, "\"")
            end

            for _, src in ipairs(context.srcs:get()) do
                builder:append_indent()
                    :append_line("\"", src, "\"")
            end

            builder:append_line(")")

            if not utils.is_name_cmake_conform(context.name) then
                builder:append_line("add_executable(", context.name, " ALIAS ", name, ")")
            end

            cmake.generator.add_action({
                kind = kind .. ".options",
                ---@param options_context { name: string, options: lua-cmake.target.options }
                func = function(options_builder, options_context)
                    target_options(options_builder, options_context.name, options_context.options)
                end,
                context = {
                    name = name,
                    options = context.options
                }
            })
        end,
        context = self.config
    })
end

return class(kind, executable)
