local utils_string = require("lua-cmake.utils.string")

---@class lua-cmake.gen.context

---@class lua-cmake.gen.action
---@field func fun(self: lua-cmake.gen.action)

---@class lua-cmake.gen
---@field m_actions lua-cmake.gen.action[]
local gen = {
    m_actions = {}
}

---@generic T : lua-cmake.gen.action
---@param action { func: fun(self: T) : string }
function gen:add_action(action)
    table.insert(self.m_actions, action)
end

---@return string
function gen:generate()
    local action_results = {}
    for _, action in ipairs(self.m_actions) do
        local result = action.func(action)
        table.insert(action_results, result)
    end
    return utils_string.join(action_results, "\n")
end

return gen
