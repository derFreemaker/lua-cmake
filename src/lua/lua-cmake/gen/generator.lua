local string_builder = require("lua-cmake.utils.string_builder")

local action_class = require("lua-cmake.gen.action")

---@class lua-cmake.gen.generator
---@field optimizer lua-cmake.perf.optimizer
---@field private m_actions lua-cmake.gen.action[]
local generator = {
    optimizer = require("lua-cmake.perf.optimizer"),
    m_actions = {},
}

local count = 0
function generator.get_count()
    return count
end
---@return integer
function generator.generate_id()
    count = count + 1
    return count
end

---@param action_config lua-cmake.gen.action.config<any>
---@return lua-cmake.gen.action
function generator.add_action(action_config)
    local action = action_class(action_config, generator)
    generator.m_actions[action.id] = action
    return action
end

---@param id integer
function generator.remove_action(id)
    generator.m_actions[id] = nil
end

---@private
---@param writer lua-cmake.utils.string_writer
---@return boolean has_error
function generator.generate(writer)
    local has_error = false

    for index, action in ipairs(generator.m_actions) do
        local config = action.config
        if config.modify_indent_before then
            writer:modify_indent(config.modify_indent_before --[[@as integer]])
        end

        local action_builder = string_builder()
        action_builder:modify_indent(writer:get_indent())

        local action_thread = coroutine.create(config.func)
        local success, msg = coroutine.resume(action_thread, action_builder, config.context)
        if not success then
            has_error = true
            cmake.error("generator action " .. index .. " failed:\n" .. debug.traceback(action_thread, msg))
        else
            writer:write_direct(action_builder:build())
        end

        if config.modify_indent_after then
            writer:modify_indent(config.modify_indent_after)
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
