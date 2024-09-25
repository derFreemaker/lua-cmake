local string_builder = require("lua-cmake.utils.string_builder")

---@class lua-cmake.gen.context

---@alias lua-cmake.gen.action.func fun(builder: lua-cmake.utils.string_builder, context: table)

---@class lua-cmake.gen.action
---@field kind string
---@field func lua-cmake.gen.action.func
---@field context table | nil

---@class lua-cmake.gen.generator
---@field optimizer lua-cmake.perf.optimizer
---@field private m_actions lua-cmake.gen.action[]
local generator = {
    optimizer = require("lua-cmake.perf.optimizer"),
    m_actions = {},
}

---@param action lua-cmake.gen.action | { [1]: string, [2]: lua-cmake.gen.action.func, [3]: table | nil }
function generator.add_action(action)
    if not action.kind then
        if not action[1] or type(action[1]) ~= "string" then
            error("actions needs a kind with type 'string'", 2)
        end
        action.kind = action[1]
        action[1] = nil
    end

    if not action.func then
        if not action[2] or type(action[2]) ~= "function" then
            error("action needs a function at 'func' or '[2]'")
        end
        action.func = action[2]
        action[2] = nil
    end

    if not action.context then
        action.context = action[3]
        action[3] = nil
    end

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
