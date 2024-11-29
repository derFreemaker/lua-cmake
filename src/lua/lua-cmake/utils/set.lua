local table_insert = table.insert

---@class lua-cmake.utils.set<T> : { empty: (fun(self: lua-cmake.utils.set<T>) : boolean), get: (fun(self: lua-cmake.utils.set<T>) : T[]), add: (fun(self: lua-cmake.utils.set<T>, value: T)), add_multiple: (fun(self: lua-cmake.utils.set<T>, value: T[])), remove: (fun(self: lua-cmake.utils.set<T>, value: T) : boolean) }
---@field data table<any, true>
local set = {}

---@return boolean
function set:empty()
    return next(self.data) == nil
end

function set:get()
    local copy = {}
    for value in pairs(self.data) do
        table_insert(copy, value)
    end
    return copy
end

---@param value any
function set:add(value)
    self.data[value] = true
end

---@param t any[]
function set:add_multiple(t)
    for _, value in pairs(t) do
        self:add(value)
    end
end

---@param value any
function set:remove(value)
    self.data[value] = nil
end

---@generic T
---@param arr T[] | nil
---@return lua-cmake.utils.set<T>
return function(arr)
    local data = {}
    if arr then
        for _, value in pairs(arr) do
            data[value] = true
        end
    end

    return setmetatable({
        data = data,
    }, {
        __index = set,
    })
end
