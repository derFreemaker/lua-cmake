---@class lua-cmake.gen.action<T> : { kind: string, func: (fun(writer: lua-cmake.utils.string_writer, context: T)), context: T, add_indent_after: boolean | nil, remove_indent_after: boolean | nil, add_indent_before: boolean | nil, remove_indent_before: boolean | nil }

---@class lua-cmake.gen.generator
---@field optimizer lua-cmake.perf.optimizer
---@field private m_actions lua-cmake.gen.action<any>[]
local generator = {
    optimizer = require("lua-cmake.perf.optimizer"),
    m_actions = {},
}

---@param action lua-cmake.gen.action<any>
function generator.add_action(action)
    table.insert(generator.m_actions, action)
end

function generator.remove_last_action()
    generator.m_actions[#generator.m_actions] = nil
end

---@private
---@param writer lua-cmake.utils.string_writer
function generator.generate(writer)
    for _, action in ipairs(generator.m_actions) do
        if action.add_indent_before then
            writer:add_indent()
        end
        if action.remove_indent_before then
            writer:remove_indent()
        end

        action.func(writer, action.context)

        if action.add_indent_after then
            writer:add_indent()
        end
        if action.remove_indent_after then
            writer:remove_indent()
        end
    end
end

---@private
function generator.optimize()
    ---@diagnostic disable-next-line: invisible
    generator.optimizer.optimize(generator.m_actions)
end

return generator
