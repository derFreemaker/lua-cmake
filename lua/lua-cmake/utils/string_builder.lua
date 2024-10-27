---@class lua-cmake.utils.string_builder : object
---@field private m_buffer string[]
---@field private m_indent integer
---@field private m_start_of_line boolean
---@overload fun() : lua-cmake.utils.string_builder
local string_builder = {}

---@private
function string_builder:__init()
    self.m_buffer = {}
    self.m_indent = 0
    self.m_start_of_line = true
end

---@private
---@return integer
function string_builder:get_indent()
    return self.m_indent
end

---@param indent integer
---@return lua-cmake.utils.string_builder
function string_builder:set_indent(indent)
    self.m_indent = indent

    return self
end

---@param indent integer | nil
---@return lua-cmake.utils.string_builder
function string_builder:modify_indent(indent)
    self.m_indent = self.m_indent + (indent or 1)
    if self.m_indent < 0 then
        self.m_indent = 0
    end

    return self
end

---@param ... any
---@return lua-cmake.utils.string_builder
function string_builder:append_direct(...)
    local args = { ... }
    for _, value in ipairs(args) do
        table.insert(self.m_buffer, tostring(value))
    end

    return self
end

---@param ... any
---@return lua-cmake.utils.string_builder
function string_builder:append(...)
    if self.m_start_of_line then
        self.m_start_of_line = false
        self:append_indent(self.m_indent)
    end

    self:append_direct(...)

    return self
end

---@param ... any
---@return lua-cmake.utils.string_builder
function string_builder:append_line(...)
    self:append(...)
    self:append("\n")

    self.m_start_of_line = true
    return self
end

---@param indent integer | nil
function string_builder:append_indent(indent)
    if not indent then
        return self:append("    ")
    end
    if indent == 0 then
        return self
    end

    for _ = 1, indent, 1 do
        table.insert(self.m_buffer, "    ")
    end
    return self
end

---@return string
function string_builder:build()
    return table.concat(self.m_buffer)
end

return class("lua-cmake.utils.string_builder", string_builder)
