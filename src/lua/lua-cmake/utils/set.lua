local utils = require("lua-cmake.utils")
local table_remove = table.remove

---@generic T
---@param arr T[]
---@param value T
---@return integer
local function array_insert(arr, value)
    local i = 0
    for j in ipairs(arr) do
        i = j
    end
    i = i + 1

    arr[i] = value
    return i
end

---@class lua-cmake.utils.set<T> : { empty: (fun(self: lua-cmake.utils.set<T>) : boolean), get: (fun(self: lua-cmake.utils.set<T>) : T[]), add: (fun(self: lua-cmake.utils.set<T>, value: T) : boolean, integer), add_multiple: (fun(self: lua-cmake.utils.set<T>, value: T[])), remove: (fun(self: lua-cmake.utils.set<T>, value: T) : boolean) }
---@field data any[]
local set = {}

---@return boolean
function set:empty()
    return #self.data == 0
end

function set:get()
    return utils.table.copy(self.data)
end

---@return boolean
---@return integer
function set:add(value)
    if utils.table.contains(self.data, value) then
        return false, -1
    end

    return true, array_insert(self.data, value)
end

function set:add_multiple(t)
    for _, value in pairs(t) do
        self:add(value)
    end
end

---@return boolean
function set:remove(value)
    for index, data_value in pairs(self.data) do
        if data_value == value then
            table_remove(self.data, index)
            return true
        end
    end

    return false
end

---@generic T
---@param arr T[] | nil
---@return lua-cmake.utils.set<T>
return function(arr)
    local data = arr or {}
    return setmetatable({
        data = data,
        empty = set.empty,
        get = set.get,
        add = set.add,
        add_multiple = set.add_multiple,
        remove = set.remove
    }, {
        __index = function(_, k)
            return data[k]
        end,
        __newindex = function(_, k, v)
            data[k] = v
        end
    })
end
