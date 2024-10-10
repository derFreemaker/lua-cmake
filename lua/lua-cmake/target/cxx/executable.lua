local utils = require("lua-cmake.utils")
local target_options = require("lua-cmake.target.options")

---@class lua-cmake.target.cxx.executable.config
---@field name string
---@field srcs string[] | nil
---@field hdrs string[] | nil
---@field deps string[] | nil
---@field win32 boolean | nil
---@field macosx_bundle boolean | nil
---@field exclude_from_all boolean | nil
---@field options lua-cmake.target.options | nil

local kind = "lua-cmake.target.cxx.executable"
---@class lua-cmake.target.cxx.executable : object
---@field config lua-cmake.target.cxx.executable.config
---@overload fun(config: lua-cmake.target.cxx.executable.config) : lua-cmake.target.cxx.executable
local executable = {}

---@alias lua-cmake.target.cxx.executable.constructor fun(config: lua-cmake.target.cxx.executable.config)

---@private
---@param config lua-cmake.target.cxx.executable.config
function executable:__init(config)
    self.config = config

    if not self.config.srcs then
        self.config.srcs = {}
    else
        cmake.path_resolver.resolve_paths(self.config.srcs)
    end

    if not self.config.options then
        self.config.options = {}
    end
    if not self.config.options.link_libraries then
        self.config.options.link_libraries = {}
    end

    if not self.config.deps then
        self.config.deps = {}
    end

    cmake.registry.add_entry({
        get_name = function()
            return self.config.name
        end,

        add_srcs = function(srcs)
            for _, src in ipairs(srcs) do
                table.insert(self.config.srcs, src)
            end
        end,
        add_links = function(links)
            for _, link in ipairs(links) do
                table.insert(self.config.options.link_libraries, link)
            end
        end,

        get_deps = function()
            return self.config.deps
        end,
    })

    cmake.generator.add_action({
        kind = kind,
        ---@param context lua-cmake.target.cxx.executable.config
        func = function(writer, context)
            writer:write_line("add_executable(", context.name)

            if context.win32 then
                writer
                    :write_indent()
                    :write_line("WIN32_EXECUTABLE")
            end

            if context.macosx_bundle then
                writer
                    :write_indent()
                    :write_line("MACOSX_BUNDLE")
            end

            if context.exclude_from_all then
                writer
                    :write_indent()
                    :write_line("EXCLUDE_FROM_ALL")
            end

            for _, src in ipairs(context.srcs) do
                writer
                    :write_indent()
                    :write_line("\"", src, "\"")
            end

            writer:write_line(")")

            cmake.generator.add_action({
                kind = kind .. ".options",
                ---@param options_context { name: string, options: lua-cmake.target.options }
                func = function(options_writer, options_context)
                    target_options(options_writer, options_context.name, options_context.options)
                end,
                context = {
                    name = context.name,
                    options = context.options
                }
            })
        end,
        context = self.config
    })
end

return class(kind, executable)
