local iterator = require("lua-cmake.perf.iterator")

---@alias lua-cmake.perf.strategy<T> fun(iter: lua-cmake.perf.actions_iterator, value: lua-cmake.gen.action<T>)

---@class lua-cmake.perf.optimizer
---@field private m_strategies table<string, lua-cmake.perf.strategy[]>
local optimizer = {
    m_strategies = {}
}

---@param kind_or_kinds string | string[]
---@param strat lua-cmake.perf.strategy<any>
function optimizer.add_strat(kind_or_kinds, strat)
    if type(kind_or_kinds) == "string" then
        kind_or_kinds = { kind_or_kinds }
    end
    ---@cast kind_or_kinds string[]

    for _, kind in ipairs(kind_or_kinds) do
        local kind_strategies = optimizer.m_strategies[kind]
        if not kind_strategies then
            kind_strategies = {}
            optimizer.m_strategies[kind] = kind_strategies
        end

        table.insert(kind_strategies, strat)
    end
end

---@private
---@param iter lua-cmake.perf.actions_iterator
---@param index integer
---@param kind string
---@param strategies lua-cmake.perf.strategy<any>[]
---@return boolean has_error
function optimizer.run_strategies(iter, index, kind, strategies)
    local has_error = false

    for _, strat in ipairs(strategies) do
        iter:set_index(index)
        while true do
            local strat_thread = coroutine.create(strat)
            local success, msg = coroutine.resume(strat_thread, iter, iter:current())
            if not success then
                has_error = true
                print("lua-cmake: optimizer strat for kind: '" .. kind .. "' failed:\n"
                    .. debug.traceback(strat_thread, msg))
            end

            if not iter:next_is_same() then
                iter:increment()
                break
            end
            iter:increment()
        end
    end

    return has_error
end

---@private
---@param actions lua-cmake.gen.action<any>[]
---@return boolean has_error
function optimizer.optimize(actions)
    local has_error = false
    local iter = iterator(actions)

    while not iter:empty() do
        local kind = actions[iter:index()].kind
        local kind_strategies = optimizer.m_strategies[kind]
        if not kind_strategies then
            iter:increment()
            goto continue
        end

        local run_has_error = optimizer.run_strategies(iter, iter:index(), kind, kind_strategies)
        if run_has_error then
            has_error = true
        end

        ::continue::
    end

    local i = 1
    for index, action in pairs(actions) do
        actions[index] = nil
        actions[i] = action
        i = i + 1
    end

    return has_error
end

return optimizer
