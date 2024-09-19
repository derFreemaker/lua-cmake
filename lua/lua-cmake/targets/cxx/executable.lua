local utils_string = require("lua-cmake.utils.string")

---@class lua-cmake.target.cxx.executable.config : object, lua-cmake.target
---@field name string
---@field srcs string[] | nil
---@field hdrs string[] | nil
---@field deps string[] | nil

---@class lua-cmake.target.cxx.executable : object, lua-cmake.target
---@field config lua-cmake.target.cxx.executable.config
---@overload fun(config: lua-cmake.target.cxx.executable.config) : lua-cmake.target.cxx.executable
local executable = {}

---@alias lua-cmake.target.cxx.executable.constructor fun(config: lua-cmake.target.cxx.executable.config)

---@private
---@param config lua-cmake.target.cxx.executable.config
function executable:__init(config)
    self.config = config
end

--------------------------------
-- lua-cmake.target
--------------------------------

---@return string
function executable:get_name()
    return self.config.name
end

---@return string
function executable:get_kind()
    return "lua-cmake.cxx.executable"
end

---@return string[]
function executable:get_deps()
    return self.config.deps or {}
end

---@return string
function executable:generate_cmake()
    local str = "add_executable(" .. self.config.name

    if type(self.config.hdrs) == "table" then
        str = str .. " " .. utils_string.join(self.config.hdrs, " ")
    end

    if type(self.config.srcs) == "table" then
        str = str .. " " .. utils_string.join(self.config.srcs, " ")
    end

    str = str .. ")"

    return str
end

return class("lua-cmake.target.cxx.executable", executable, { Inherit = require("lua-cmake.cmake.target") })
