local target_options = require("lua-cmake.target.options")

---@class lua-cmake.target.cxx.library.config
---@field name string
---@field srcs string[] | nil
---@field hdrs string[] | nil
---@field deps string[] | nil
---@field type "static" | "shared" | "module" | nil
---@field exclude_from_all boolean | nil
---@field options lua-cmake.target.options | nil

---@class lua-cmake.target.cxx.library : object
---@field config lua-cmake.target.cxx.library.config
---@overload fun(config: lua-cmake.target.cxx.library.config) : lua-cmake.target.cxx.library
local library = {}

---@alias lua-cmake.target.cxx.library.constructor fun(config: lua-cmake.target.cxx.library.config)

---@private
---@param config lua-cmake.target.cxx.library.config
function library:__init(config)
    self.config = config

    cmake.generator.add_action({
        kind = "lua-cmake.target.cxx.library",
        ---@param context lua-cmake.target.cxx.library.config
        func = function(writer, context)
            writer:write_line("add_library(", context.name)
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

            target_options(writer, context.name, context.options)
        end,
        context = self.config
    })
end

cmake.targets.cxx.library = library
return class("lua-cmake.target.cxx.library", library)
