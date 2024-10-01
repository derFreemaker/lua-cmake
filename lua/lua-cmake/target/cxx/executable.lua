local target_options = require("lua-cmake.target.options")

---@class lua-cmake.target.cxx.executable.config
---@field name string
---@field srcs string[] | nil
---@field hdrs string[] | nil
---@field deps string[] | nil
---@field win32 boolean | nil
---@field macosx_bundle boolean | nil
---@field exclude_from_all boolean | nil
---@field options lua-cmake.target.options | nil

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
        func = function(writer, context)
            writer:write_line("add_executable(", context.name)

            if context.win32 then
                writer
                    :write_indent()
                    :write_line("WIN32_EXECUTABLE")
            end

            if context.macosx_bundle then
                writer
                    :write_indent()
                    :write_line("MACOSX_BUNDLE")
            end

            if context.exclude_from_all then
                writer
                    :write_indent()
                    :write_line("EXCLUDE_FROM_ALL")
            end

            for _, src in ipairs(context.srcs) do
                writer
                    :write_indent()
                    :write_line("\"", src, "\"")
            end

            writer:write_line(")")

            target_options(writer, context.name, context.options)
        end,
        context = self.config
    })
end

cmake.targets.cxx.executable = executable
return class("lua-cmake.target.cxx.executable", executable)
