local utils = require("lua-cmake.utils")

---@class lua-cmake.target.imported.library.config
---@field name string
---@field type "static" | "shared" | "module" | "unknown"
---@field global boolean | nil

local kind = "lua-cmake.target.imported.library"
---@class lua-cmake.target.imported.library : object
---@field config lua-cmake.target.imported.library.config
---@overload fun(config: lua-cmake.target.imported.library.config) : lua-cmake.target.imported.library
local library = {}

---@alias lua-cmake.target.imported.library.constructor fun(config: lua-cmake.target.imported.library.config)

---@private
---@param config lua-cmake.target.imported.library.config
function library:__init(config)
    self.config = utils.table.readonly(config)

    cmake.generator.add_action({
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

    cmake.registry.add_entry({
        kind = kind,
        get_name = function()
            return self.config.name
        end,

        on_dep = function(entry)
            entry.add_links({ self.config.name })
        end,
    })
end

return class(kind, library)
