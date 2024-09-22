---@class lua-cmake.target.cxx.library.config : object
---@field name string
---@field srcs string[] | nil
---@field hdrs string[] | nil
---@field deps string[] | nil
---@field type "static" | "shared" | "module" | nil
---@field exclude_from_all boolean | nil

---@class lua-cmake.target.cxx.library : object
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

    cmake.generator.add_action({
        kind = "lua-cmake.cxx.library",
        ---@param context lua-cmake.target.cxx.library.config
        func = function(builder, context)
            builder:append_line("add_library(", context.name)

            if context.type then
                builder:append_line("    ", context.type:upper())
            end

            if context.exclude_from_all then
                builder:append_line("    EXCLUDE_FROM_ALL")
            end

            for _, value in ipairs(context.srcs) do
                builder:append_line("    ", "\"", value, "\"")
            end

            builder:append_line(")")
        end,
        context = self.config
    })
end

return class("lua-cmake.target.cxx.library", library)
