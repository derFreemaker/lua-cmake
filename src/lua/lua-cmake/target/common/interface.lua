local utils = require("lua-cmake.utils")
local target_options = require("lua-cmake.target.options")

---@class lua-cmake.target.interface.config
---@field name string
---@field hdrs string[] | nil
---@field srcs string[] | nil
---@field exclude_from_all boolean | nil
---@field options lua-cmake.target.options | nil
---
---@field deps string[] | nil

local kind = "lua-cmake.target.interface"
---@class lua-cmake.target.interface : object
---@field config lua-cmake.target.interface.config
---@overload fun(config: lua-cmake.target.interface.config) : lua-cmake.target.interface
local interface = {}

---@private
---@param config lua-cmake.target.interface.config
function interface:__init(config)
    self.config = config
    self.links = {}

    if self.config.hdrs then
        cmake.path_resolver.resolve_paths_implace(self.config.hdrs)
    else
        self.config.hdrs = {}
    end

    if self.config.srcs then
        cmake.path_resolver.resolve_paths_implace(self.config.srcs)
    else
        self.config.srcs = {}
    end

    if not self.config.options then
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

        get_deps = function()
            return self.config.deps
        end,

        add_hdrs = function(hdrs)
            for _, hdr in ipairs(hdrs) do
                if utils.table.contains(self.config.hdrs, hdr) then
                    goto continue
                end

                table.insert(self.config.hdrs, hdr)

                ::continue::
            end
        end,
        add_srcs = function(srcs)
            for _, src in ipairs(srcs) do
                if utils.table.contains(self.config.srcs, src) then
                    goto continue
                end

                table.insert(self.config.srcs, src)

                ::continue::
            end
        end,
        add_links = function(links)
            for _, link in ipairs(links) do
                if utils.table.contains(self.config.options.link_libraries, link) then
                    goto continue
                end

                table.insert(self.config.options.link_libraries, link)

                ::continue::
            end
        end,
        on_dep = function(entry)
            entry.add_links({ self.config.name })
        end
    })

    cmake.generator.add_action({
        kind = kind,
        ---@param context lua-cmake.target.interface.config
        func = function(builder, context)
            local name = utils.make_name_cmake_conform(context.name)
            builder:append_line("add_library(", name, " INTERFACE")

            if context.exclude_from_all then
                builder:append_indent()
                    :append_line("EXCLUDE_FROM_ALL")
            end

            for _, hdr in ipairs(context.hdrs) do
                builder:append_indent()
                    :append_line("\"", hdr, "\"")
            end

            for _, src in ipairs(context.srcs) do
                builder:append_indent()
                    :append_line("\"", src, "\"")
            end

            builder:append_line(")")

            if not utils.is_name_cmake_conform(context.name) then
                builder:append_line("add_library(", context.name, " ALIAS ", name, ")")
            end

            cmake.generator.add_action({
                kind = kind .. ".options",
                ---@param options_context { name: string, options: lua-cmake.target.options }
                func = function(options_builder, options_context)
                    target_options(options_builder, options_context.name, options_context.options, true)
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

return class(kind, interface)
