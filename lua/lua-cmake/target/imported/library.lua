---@class lua-cmake.target.imported.library.config : object
---@field name string
---@field type "static" | "shared" | "module" | "unknown"
---@field global boolean | nil

---@class lua-cmake.target.imported.library : object
---@field config lua-cmake.target.imported.library.config
---@overload fun(config: lua-cmake.target.imported.library.config) : lua-cmake.target.imported.library
local library = {}

---@alias lua-cmake.target.imported.library.constructor fun(config: lua-cmake.target.imported.library.config)

---@private
---@param config lua-cmake.target.imported.library.config
function library:__init(config)
    self.config = config

    cmake.generator.add_action({
        kind = "lua-cmake.target.imported.library",
        ---@param context lua-cmake.target.imported.library.config
        func = function(writer, context)
            writer:write("add_library(", context.name, " ", context.type:upper(), " IMPORTED")

            if context.global then
                writer:write(" GLOBAL")
            end

            writer:write_line(")")
        end,
        context = self.config
    })
end

return class("lua-cmake.target.imported.library", library)
