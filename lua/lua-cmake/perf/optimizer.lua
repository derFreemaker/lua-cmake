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
function optimizer.run_strategies(iter, index, kind, strategies)
    for _, strat in ipairs(strategies) do
        iter:set_index(index)
        while true do
            strat(iter, iter:current())

            if not iter:next_is_same() then
                iter:increment()
                break
            end
            iter:increment()
        end
    end
end

---@private
---@param actions lua-cmake.gen.action<any>[]
function optimizer.optimize(actions)
    local iter = iterator(actions)

    while not iter:empty() do
        local kind = actions[iter:index()].kind
        local kind_strategies = optimizer.m_strategies[kind]
        if not kind_strategies then
            iter:increment()
            goto continue
        end

        optimizer.run_strategies(iter, iter:index(), kind, kind_strategies)

        ::continue::
    end

    local i = 1
    for index, action in pairs(actions) do
        actions[index] = nil
        actions[i] = action
        i = i + 1
    end
end

return optimizer
