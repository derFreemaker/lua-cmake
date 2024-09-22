---@class lua-cmake.utils.string_builder : object
---@field private m_buffer string[]
---@overload fun() : lua-cmake.utils.string_builder
local string_builder = {}

---@private
function string_builder:__init()
    self.m_buffer = {}
end

---@param ... any
---@return lua-cmake.utils.string_builder
function string_builder:append(...)
    local args = {...}
    for _, value in ipairs(args) do
        table.insert(self.m_buffer, tostring(value))
    end

    return self
end

---@param ... any
---@return lua-cmake.utils.string_builder
function string_builder:append_line(...)
    local args = {...}
    for _, value in ipairs(args) do
        table.insert(self.m_buffer, tostring(value))
    end
    table.insert(self.m_buffer, "\n")

    return self
end

---@return string
function string_builder:build()
    return table.concat(self.m_buffer)
end

return class("lua-cmake.utils.string_builder", string_builder)
