---@generic T
---@class lua-cmake.reference<T> : { set: (fun(self: lua-cmake.reference<T>, value: T)), get: (fun(self: lua-cmake.reference<T>) : T) }
---@field private m_value any
local reference = {}

---@param value any
function reference:set(value)
    self.m_value = value
end

---@return any
function reference:get()
    return self.m_value
end

---@generic T
---@param value `T` | nil
---@return lua-cmake.reference<T>
return function (value)
    return setmetatable({
        m_value = value
    }, {
        index = reference
    })
end
