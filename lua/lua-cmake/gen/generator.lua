local string_builder = require("lua-cmake.utils.string_builder")

---@class lua-cmake.gen.context

---@class lua-cmake.gen.action
---@field kind string
---@field func fun(builder: lua-cmake.utils.string_builder, context: table)
---@field context table | nil

---@class lua-cmake.gen.generator
---@field optimizer lua-cmake.perf.optimizer
---@field private m_actions lua-cmake.gen.action[]
local generator = {
    optimizer = require("lua-cmake.perf.optimizer"),
    m_actions = {},
}

---@param action lua-cmake.gen.action
function generator.add_action(action)
    table.insert(generator.m_actions, action)
end

---@private
---@return string
function generator.generate()
    local builder = string_builder()
    for _, action in ipairs(generator.m_actions) do
        action.func(builder, action.context or {})
    end
    return builder:build()
end

---@private
function generator.optimize()
    ---@diagnostic disable-next-line: invisible
    generator.optimizer.optimize(generator.m_actions)
end

return generator
