local string_builder = require("lua-cmake.utils.string_builder")

---@class lua-cmake.gen.action<T> : { kind: string, func: (fun(writer: lua-cmake.utils.string_builder, context: T)), context: T, modify_indent_before: integer | nil, modify_indent_after: integer | nil }

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
---@return boolean has_error
function generator.generate(writer)
    local has_error = false

    for index, action in ipairs(generator.m_actions) do
        if action.modify_indent_before then
            writer:modify_indent(action.modify_indent_before --[[@as integer]])
        end

        local action_builder = string_builder()
        action_builder:modify_indent(writer:get_indent())

        local action_thread = coroutine.create(action.func)
        local success, msg = coroutine.resume(action_thread, action_builder, action.context)
        if not success then
            has_error = true
            cmake.error("generator action " .. index .. " failed:\n" .. debug.traceback(action_thread, msg))
        else
            writer:write_direct(action_builder:build())
        end

        if action.modify_indent_after then
            writer:modify_indent(action.modify_indent_after)
        end
    end

    return has_error
end

---@private
---@return boolean has_error
function generator.optimize()
    ---@diagnostic disable-next-line: invisible
    return generator.optimizer.optimize(generator.m_actions)
end

return generator
