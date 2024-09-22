---@class lua-cmake.target.cxx.executable.config : object
---@field name string
---@field srcs string[] | nil
---@field hdrs string[] | nil
---@field deps string[] | nil

---@class lua-cmake.target.cxx.executable : object
---@field config lua-cmake.target.cxx.executable.config
---@overload fun(config: lua-cmake.target.cxx.executable.config) : lua-cmake.target.cxx.executable
local executable = {}

---@alias lua-cmake.target.cxx.executable.constructor fun(config: lua-cmake.target.cxx.executable.config)

---@private
---@param config lua-cmake.target.cxx.executable.config
function executable:__init(config)
    self.config = config

    -- cmake.generator.add_action({
    --     kind = "lua-cmake.cxx.executable",
    --     func = function(context)
    --         local str = 
    --     end
    -- })
end

return class("lua-cmake.target.cxx.executable", executable)
