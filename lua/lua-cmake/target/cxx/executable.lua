---@class lua-cmake.target.cxx.executable.config : object
---@field name string
---@field srcs string[] | nil
---@field hdrs string[] | nil
---@field deps string[] | nil
---@field win32 boolean | nil
---@field macosx_bundle boolean | nil
---@field exclude_from_all boolean | nil

---@class lua-cmake.target.cxx.executable : object
---@field config lua-cmake.target.cxx.executable.config
---@overload fun(config: lua-cmake.target.cxx.executable.config) : lua-cmake.target.cxx.executable
local executable = {}

---@alias lua-cmake.target.cxx.executable.constructor fun(config: lua-cmake.target.cxx.executable.config)

---@private
---@param config lua-cmake.target.cxx.executable.config
function executable:__init(config)
    self.config = config

    cmake.generator.add_action({
        kind = "lua-cmake.target.cxx.executable",
        ---@param context lua-cmake.target.cxx.executable.config
        func = function(builder, context)
            builder:append_line("add_executable(", context.name)

            if context.win32 then
                builder:append_line("    WIN32_EXECUTABLE")
            end

            if context.macosx_bundle then
                builder:append_line("    MACOSX_BUNDLE")
            end

            if context.exclude_from_all then
                builder:append_line("    EXCLUDE_FROM_ALL")
            end

            for _, src in ipairs(context.srcs) do
                builder:append_line("    \"", src, "\"")
            end

            builder:append_line(")")
        end,
        context = self.config
    })
end

return class("lua-cmake.target.cxx.executable", executable)
