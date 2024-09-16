local registry = require("lua-cmake.cmake.registry")

---@class lua-cmake.target.cxx.library.config : object, lua-cmake.target
---@field name string
---@field srcs string[] | nil
---@field hdrs string[] | nil
---@field deps string[] | nil
---@field static boolean | nil

---@class lua-cmake.target.cxx.library : object, lua-cmake.target
---@field config lua-cmake.target.cxx.library.config
---@overload fun(config: lua-cmake.target.cxx.library.config) : lua-cmake.target.cxx.library
local library = {}

---@alias lua-cmake.target.cxx.library.constructor fun(config: lua-cmake.target.cxx.library.config)

---@private
---@param config lua-cmake.target.cxx.library.config
function library:__init(config)
    self.config = config

    registry:add_target(self)
end

--------------------------------
-- lua-cmake.target
--------------------------------

---@return string
function library:get_name()
    return self.config.name
end

---@return string
function library:get_kind()
    return "lua-cmake.cxx.library"
end

---@return string
function library:generate_cmake()
    return "lua-cmake.cxx.library"
end

return class("lua-cmake.target.cxx.library", library, { Inherit = require("lua-cmake.cmake.target") })
