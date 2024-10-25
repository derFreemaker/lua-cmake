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
        func = function(writer, context)
            writer:write("project(", context.name)

            if not context.version
                and not context.description
                and not context.homepage_url
                and not context.languages then
                writer:write_line(")")
                return
            end
            writer:write_line()

            if context.version then
                writer:write_indent()
                    :write_line("VERSION ", context.version.major, ".", context.version.minor or 0, ".", context.version.patch or 0, ".", context.version.tweak or 0)
            end

            if context.description then
                writer:write_indent()
                    :write_line("DESCRIPTION \"", context.description, "\"")
            end

            if context.homepage_url then
                writer:write_indent()
                    :write_line("HOMEPAGE_URL \"", context.homepage_url, "\"")
            end

            if context.languages then
                writer:write_indent()
                    :write("LANGUAGES")

                if #context.languages == 1 then
                    writer:write_line(" ", context.languages[1])
                else
                    writer:write_line()
                    for _, lang in ipairs(context.languages) do
                        writer:write_indent(2):write_line(lang)
                    end
                end
            end

            writer:write_line(")")
        end,
        context = self.config
    })
end

return class(kind, project)
