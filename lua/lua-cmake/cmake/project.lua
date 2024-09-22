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
            writer:append("project(", context.name)

            local details = false
            if context.version then
                details = true

                writer:append("\n    VERSION ", context.version.major)
                writer:append(".", context.version.minor or 0)
                writer:append(".", context.version.patch or 0)
                writer:append(".", context.version.tweak or 0)
            end

            if context.description then
                details = true

                writer:append("\n    DESCRIPTION \"", context.description, "\"")
            end

            if context.homepage_url then
                details = true

                writer:append("\n    HOMEPAGE_URL \"", context.homepage_url, "\"")
            end

            if context.languages then
                details = true

                writer:append("\n    LANGUAGES")
                for _, lang in ipairs(context.languages) do
                    writer:append(" ", lang)
                end
            end

            if details then
                writer:append_line()
            end
            writer:append_line(")")
        end,
        context = self.config
    })
end

return class("lua-cmake.cmake.project", project)
