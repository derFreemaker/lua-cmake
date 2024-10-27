---@alias lua-cmake.utils.string_writer.write fun(str: string)

---@class lua-cmake.utils.string_writer : object
---@field private m_write lua-cmake.utils.string_writer.write
---@field private m_indent integer
---@field private m_start_of_line boolean
---@overload fun(write: lua-cmake.utils.string_writer.write) : lua-cmake.utils.string_writer
local string_writer = {}

---@private
---@param write lua-cmake.utils.string_writer.write
function string_writer:__init(write)
    self.m_write = write
    self.m_indent = 0
    self.m_start_of_line = true
end

---@return integer
function string_writer:get_indent()
    return self.m_indent
end

---@param indent integer
---@return lua-cmake.utils.string_writer
function string_writer:set_indent(indent)
    self.m_indent = indent

    return self
end

---@param indent integer | nil
---@return lua-cmake.utils.string_writer
function string_writer:modify_indent(indent)
    self.m_indent = self.m_indent + (indent or 1)
    if self.m_indent < 0 then
        self.m_indent = 0
    end

    return self
end

---@param ... any
function string_writer:write_direct(...)
    for _, value in ipairs({ ... }) do
        self.m_write(tostring(value))
    end
end

---@param ... any
---@return lua-cmake.utils.string_writer
function string_writer:write(...)
    if self.m_start_of_line then
        self.m_start_of_line = false
        self:write_indent(self.m_indent)
    end

    self:write_direct(...)
    return self
end

---@param ... any
---@return lua-cmake.utils.string_writer
function string_writer:write_line(...)
    self:write(...)
    self:write("\n")

    self.m_start_of_line = true
    return self
end

---@param indent integer | nil
---@return lua-cmake.utils.string_writer
function string_writer:write_indent(indent)
    if not indent then
        return self:write("    ")
    end

    if indent == 0 then
        return self
    end

    local indents = {}
    for _ = 1, indent, 1 do
        table.insert(indents, "    ")
    end

    return self:write(table.concat(indents))
end

return class("lua-cmake.utils.string_writer", string_writer)
