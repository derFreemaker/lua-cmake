---@class lua-cmake.cmake.project.config
---@field name string
---@field version { major: integer, minor: integer | nil, patch: integer | nil, tweak: integer } | nil
---@field description string | nil
---@field homepage_url string | nil
---@field languages string[] | nil

---@class lua-cmake.cmake.project : object
---@field config lua-cmake.cmake.project.config
local project = {}

---@param config lua-cmake.cmake.project.config
function project:__init(config)
    self.config = config

    cmake.generator.add_action({
        kind = "lua-cmake.cmake.project",
        ---@param context lua-cmake.cmake.project.config
        func = function(writer, context)
            writer:write("project(", context.name)

            local details = false
            if context.version then
                details = true

                writer
                    :write_line()
                    :write("    VERSION ", context.version.major)
                    :write(".", context.version.minor or 0)
                    :write(".", context.version.patch or 0)
                    :write(".", context.version.tweak or 0)
            end

            if context.description then
                details = true

                writer
                    :write_line()
                    :write("    DESCRIPTION \"", context.description, "\"")
            end

            if context.homepage_url then
                details = true

                writer
                    :write_line()
                    :write("    HOMEPAGE_URL \"", context.homepage_url, "\"")
            end

            if context.languages then
                details = true

                writer
                    :write_line()
                    :write("    LANGUAGES")
                for _, lang in ipairs(context.languages) do
                    writer:write(" ", lang)
                end
            end

            if details then
                writer:write_line()
            end
            writer:write_line(")")
        end,
        context = self.config
    })
end

return class("lua-cmake.cmake.project", project)
