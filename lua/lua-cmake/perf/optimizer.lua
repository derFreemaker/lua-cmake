local iterator = require("lua-cmake.perf.iterator")

---@alias lua-cmake.perf.strategy fun(iter: lua-cmake.perf.actions_iterator, value: lua-cmake.gen.action) | fun(iter: lua-cmake.perf.actions_iterator)

---@class lua-cmake.perf.optimizer
---@field private m_strategies table<string, lua-cmake.perf.strategy[]>
local optimizer = {
    m_strategies = {}
}

---@param kind string | string[]
---@param strat lua-cmake.perf.strategy
function optimizer.add_strat(kind, strat)
    local kind_strategies = optimizer.m_strategies[kind]
    if not kind_strategies then
        kind_strategies = {}
        optimizer.m_strategies[kind] = kind_strategies
    end

    table.insert(kind_strategies, strat)
end

---@private
---@param iter lua-cmake.perf.actions_iterator
---@param kind string
---@param strategies lua-cmake.perf.strategy[]
function optimizer.run_strategies(iter, kind, strategies)
    for _, strat in ipairs(strategies) do
        while true do
            strat(iter, iter:current())
            iter:increment()

            if not iter:current() or iter:current().kind ~= kind then
                return
            end
        end
    end
end

---@private
---@param actions lua-cmake.gen.action[]
function optimizer.optimize(actions)
    local iter = iterator(actions)

    local actions_count = #actions
    while iter:index() < actions_count do
        local kind = actions[iter:index()].kind
        local kind_strategies = optimizer.m_strategies[kind]
        if not kind_strategies then
            iter:increment()
            goto continue
        end

        optimizer.run_strategies(iter, kind, kind_strategies)

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
