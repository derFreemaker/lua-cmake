---@class lua-cmake.perf.actions_iterator : object
---@field private m_actions lua-cmake.gen.action[]
---@field private m_index integer
---@overload fun(actions: lua-cmake.gen.action[]) : lua-cmake.perf.actions_iterator
local iterator = {}

---@private
---@param actions lua-cmake.gen.action[]
function iterator:__init(actions)
    self.m_actions = actions
    self.m_index = 1
end

---@return integer
function iterator:index()
    return self.m_index
end

---@return lua-cmake.gen.action
function iterator:current()
    return self.m_actions[self.m_index]
end

---@return lua-cmake.gen.action
function iterator:next()
    return self.m_actions[self.m_index + 1]
end

---@return boolean
function iterator:next_exists()
    return self.m_actions[self.m_index + 1] ~= nil
end

---@param kind string
---@return boolean
function iterator:next_is(kind)
    local next = self:next()
    if not next then
        return false
    end

    return next.kind == kind
end

function iterator:next_is_same()
    local next = self:next()
    if not next then
        return false
    end

    local current = self.m_actions[self.m_index]
    return next.kind == current.kind
end

function iterator:increment()
    self.m_index = self.m_index + 1
end

---@param index integer
function iterator:pop(index)
    self.m_actions[index] = nil
end

function iterator:pop_current()
    self.m_actions[self.m_index] = nil
end

function iterator:pop_next()
    table.remove(self.m_actions, self.m_index + 1)
end

class("lua-cmake.perf.actions_iterator", iterator)

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
---@param actions lua-cmake.gen.action[]
function optimizer.optimize(actions)
    local iter = iterator(actions)

    while iter:index() < #actions do
        local kind = actions[iter:index()].kind
        local kind_strategies = optimizer.m_strategies[kind]
        if not kind_strategies then
            iter:increment()
            goto continue
        end

        for _, strat in ipairs(kind_strategies) do
            while iter:current() ~= nil do
                strat(iter, iter:current())
            end
        end

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
