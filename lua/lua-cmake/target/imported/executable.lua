---@class lua-cmake.target.imported.executable.config : object
---@field name string
---@field global boolean | nil

---@class lua-cmake.target.imported.executable : object
---@field config lua-cmake.target.imported.executable.config
---@overload fun(config: lua-cmake.target.imported.executable.config) : lua-cmake.target.imported.executable
local executable = {}

---@alias lua-cmake.target.imported.executable.constructor fun(config: lua-cmake.target.imported.executable.config)

---@private
---@param config lua-cmake.target.imported.executable.config
function executable:__init(config)
    self.config = config

    cmake.generator.add_action({
        kind = "lua-cmake.target.imported.executable",
        ---@param context lua-cmake.target.imported.executable.config
        func = function(write, context)
            write:write("add_executable(", context.name, " IMPORTED")

            if context.global then
                write:write(" GLOBAL")
            end

            write:write_line(")")
        end,
        context = self.config
    })
end

return class("lua-cmake.target.imported.executable", executable)
