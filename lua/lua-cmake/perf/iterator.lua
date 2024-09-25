---@class lua-cmake.perf.actions_iterator : object
---@field private m_index integer
---@field private m_end integer
---@field private m_current lua-cmake.gen.action
---@field private m_actions lua-cmake.gen.action[]
---@overload fun(actions: lua-cmake.gen.action[]) : lua-cmake.perf.actions_iterator
local iterator = {}

---@private
---@param actions lua-cmake.gen.action[]
function iterator:__init(actions)
    self.m_index = 1
    self.m_actions = actions
    self.m_end = #actions + 1
    self.m_current = self.m_actions[self.m_index]
end

---@return boolean
function iterator:empty()
    return self.m_index == self.m_end
end

---@return integer
function iterator:index()
    return self.m_index
end

---@return lua-cmake.gen.action
function iterator:current()
    return self.m_current
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

    return next.kind == self.m_current.kind
end

function iterator:increment()
    while self.m_index < self.m_end do
        self.m_index = self.m_index + 1
        self.m_current = self.m_actions[self.m_index]

        if self.m_current ~= nil then
            return
        end
    end
end

---@param index integer
function iterator:remove(index)
    self.m_actions[index] = nil
end

function iterator:remove_current()
    self.m_actions[self.m_index] = nil
end

function iterator:remove_next()
    self.m_actions[self.m_index + 1] = nil
end

return class("lua-cmake.perf.actions_iterator", iterator)
