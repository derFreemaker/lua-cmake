local utils = require("lua-cmake.utils")
local target_options = require("lua-cmake.target.options")

---@class lua-cmake.target.cxx.library.config
---@field name string
---@field srcs string[] | nil
---@field hdrs string[] | nil
---@field deps string[] | nil
---@field type "static" | "shared" | "module" | nil
---@field exclude_from_all boolean | nil
---@field options lua-cmake.target.options | nil

local kind = "lua-cmake.target.cxx.library"
---@class lua-cmake.target.cxx.library : object
---@field config lua-cmake.target.cxx.library.config
---@overload fun(config: lua-cmake.target.cxx.library.config) : lua-cmake.target.cxx.library
local library = {}

---@alias lua-cmake.target.cxx.library.constructor fun(config: lua-cmake.target.cxx.library.config)

---@private
---@param config lua-cmake.target.cxx.library.config
function library:__init(config)
    self.config = config

    if not self.config.hdrs then
        self.config.hdrs = {}
    else
        cmake.path_resolver.resolve_paths_implace(self.config.hdrs)
    end

    if not self.config.srcs then
        self.config.srcs = {}
    else
        cmake.path_resolver.resolve_paths_implace(self.config.srcs)
    end

    if not self.config.deps then
        self.config.deps = {}
    end

    if not self.config.options then
        self.config.options = {}
    end
    if not self.config.options.link_libraries then
        self.config.options.link_libraries = {}
    end

    cmake.registry.add_entry({
        get_name = function()
            return self.config.name
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

        get_deps = function()
            return self.config.deps
        end,

        on_dep = function(entry)
            entry.add_links({ self.config.name })
        end,
    })

    cmake.generator.add_action({
        kind = kind,
        ---@param context lua-cmake.target.cxx.library.config
        func = function(writer, context)
            local name = utils.make_name_cmake_conform(context.name)
            writer:write_line("add_library(", name)
            if context.type then
                writer
                    :write_indent()
                    :write_line(context.type:upper())
            end

            if context.exclude_from_all then
                writer
                    :write_indent()
                    :write_line("EXCLUDE_FROM_ALL")
            end

            for _, value in ipairs(context.srcs) do
                writer
                    :write_indent()
                    :write_line("\"", value, "\"")
            end

            writer:write_line(")")

            if not utils.is_name_cmake_conform(context.name) then
                writer:write_line("add_library(", context.name, " ALIAS ", name, ")")
            end

            cmake.generator.add_action({
                kind = kind .. ".options",
                ---@param options_context { name: string, options: lua-cmake.target.options }
                func = function(options_writer, options_context)
                    target_options(options_writer, options_context.name, options_context.options)
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

return class(kind, library)
