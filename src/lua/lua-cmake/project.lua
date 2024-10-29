---@class lua-cmake.project.config
---@field name string
---@field version { major: integer, minor: integer | nil, patch: integer | nil, tweak: integer } | nil
---@field description string | nil
---@field homepage_url string | nil
---@field languages string[] | nil

local kind = "lua-cmake.project"
---@class lua-cmake.project : object
---@field config lua-cmake.project.config
---@overload fun(config: lua-cmake.project.config) : lua-cmake.project
local project = {}

---@private
---@param config lua-cmake.project.config
function project:__init(config)
    self.config = config

    cmake.generator.add_action({
        kind = kind,
        ---@param context lua-cmake.project.config
        func = function(builder, context)
            builder:append("project(", context.name)

            if not context.version
                and not context.description
                and not context.homepage_url
                and not context.languages then
                builder:append_line(")")
                return
            end
            builder:append_line()

            if context.version then
                builder:append_indent()
                    :append_line("VERSION ", context.version.major, ".", context.version.minor or 0, ".", context.version.patch or 0, ".", context.version.tweak or 0)
            end

            if context.description then
                builder:append_indent()
                    :append_line("DESCRIPTION \"", context.description, "\"")
            end

            if context.homepage_url then
                builder:append_indent()
                    :append_line("HOMEPAGE_URL \"", context.homepage_url, "\"")
            end

            if context.languages then
                builder:append_indent()
                    :append("LANGUAGES")

                if #context.languages == 1 then
                    builder:append_line(" ", context.languages[1])
                else
                    builder:append_line()
                    for _, lang in ipairs(context.languages) do
                        builder:append_indent(2)
                            :append_line(lang)
                    end
                end
            end

            builder:append_line(")")
        end,
        context = self.config
    })
end

return class(kind, project)
