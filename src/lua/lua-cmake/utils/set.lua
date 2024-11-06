local table_insert = table.insert

---@class lua-cmake.utils.set<T> : { empty: (fun(self: lua-cmake.utils.set<T>) : boolean), get: (fun(self: lua-cmake.utils.set<T>) : T[]), add: (fun(self: lua-cmake.utils.set<T>, value: T) : boolean, integer), add_multiple: (fun(self: lua-cmake.utils.set<T>, value: T[])), remove: (fun(self: lua-cmake.utils.set<T>, value: T) : boolean) }
---@field data table<any, true>
local set = {}

---@return boolean
function set:empty()
    return #self.data == 0
end

function set:get()
    local copy = {}
    for value in pairs(self.data) do
        table_insert(copy, value)
    end
    return copy
end

---@return boolean
function set:add(value)
    if self.data[value] == true then
        return false
    end

    self.data[value] = true
    return true
end

function set:add_multiple(t)
    for _, value in pairs(t) do
        self:add(value)
    end
end

function set:remove(value)
    self.data[value] = nil
end

---@generic T
---@param arr T[] | nil
---@return lua-cmake.utils.set<T>
return function(arr)
    return setmetatable({
        data = arr or {},
    }, {
        __index = set,
    })
end
