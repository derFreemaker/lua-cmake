local generator = require("lua-cmake.gen.generator")
local utils_string = require("lua-cmake.utils.string")
local utils_table = require("lua-cmake.utils.table")

---@class lua-cmake.target.cxx.library.config : object
---@field name string
---@field srcs string[] | nil
---@field hdrs string[] | nil
---@field deps string[] | nil
---@field type "static" | "shared" | "module" | nil
---@field exclude_from_all boolean | nil

---@class lua-cmake.target.cxx.library : object, lua-cmake.target
---@field config lua-cmake.target.cxx.library.config
---@overload fun(config: lua-cmake.target.cxx.library.config) : lua-cmake.target.cxx.library
local library = {}

---@alias lua-cmake.target.cxx.library.constructor fun(config: lua-cmake.target.cxx.library.config)

---@private
---@param config lua-cmake.target.cxx.library.config
function library:__init(config)
    if config.type ~= "static" and config.type ~= "shared" and config.type ~= "module" then
        error("unsupported library type: " .. config.type)
    end

    self.config = config

    generator:add_action({
        kind = "lua-cmake.cxx.library",
        ---@param context lua-cmake.target.cxx.library
        func = function(context)
            local str = "add_library("
            str = str .. context.config.name .. " "

            if context.config.type then
                str = str .. context.config.type:upper() .. " "
            end

            if context.config.exclude_from_all then
                str = str .. "EXCLUDE_FROM_ALL "
            end

            str = str .. utils_string.join(
                utils_table.map(context.config.srcs, function(value)
                    return "\"" .. value .. "\""
                end),
                " ")
            str = str .. ")"

            return str
        end,
        context = {
            config = self.config
        }
    })
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

---@return string[]
function library:get_deps()
    return self.config.deps
end

return class("lua-cmake.target.cxx.library", library, { Inherit = require("lua-cmake.cmake.target") })
