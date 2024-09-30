---@class lua-cmake.imported.package.config
---@field name string
---@field version string | nil
---@field exact boolean | nil
---@field quiet boolean | nil
---@field required boolean | nil
---@field components string[] | nil
---@field optional_components string[] | nil
---@field search_mode "config" | "no_module" | nil
---@field global boolean | nil
---@field no_policy_scope boolean | nil
---@field bypass_provider boolean | nil
---@field names string[] | nil
---@field configs string[] | nil
---@field hints string[] | nil
---@field paths string[] | nil
---@field registry_view "64" | "32" | "64_32" | "host" | "target" | "both" | nil
---@field path_suffixes string[] | nil
---@field no_default_path boolean | nil
---@field no_package_root_path boolean | nil
---@field no_cmake_path boolean | nil
---@field no_cmake_environment_path boolean | nil
---@field no_system_environment_path boolean | nil
---@field no_cmake_package_registry boolean | nil
---@field no_cmake_system_path boolean | nil
---@field no_cmake_install_prefix boolean | nil
---@field no_cmake_system_package_registry boolean | nil
---@field cmake_find_root_path "both" | "only" | "no" | nil

---@class lua-cmake.imported.package : object
---@field private m_config lua-cmake.imported.package.config
local package = {}

---@private
---@param config lua-cmake.imported.package.config
function package:__init(config)
    self.m_config = config

    cmake.generator.add_action({
        kind = "cmake-find_package",
        ---@param context lua-cmake.imported.package.config
        func = function(writer, context)
            writer:write("find_package(", context.name)

            if context.version then
                writer:write_indent():write_line(context.version)
            end

            if context.exact then
                writer:write_indent():write_line("EXACT")
            end

            if context.quiet then
                writer:write_indent():write_line("QUIET")
            end

            if context.required then
                writer:write_indent():write_line("REQUIRED")
            end

            if context.components and #context.components > 0 then
                writer:write_indent():write_line("COMPONENTS")

                for _, value in ipairs(context.components) do
                    writer:write_indent(2):write_line("\"", value, "\"")
                end
            end

            if context.optional_components and #context.optional_components > 0 then
                writer:write_indent():write_line("OPTIONAL_COMPONENTS")

                for _, value in ipairs(context.optional_components) do
                    writer:write_indent(2):write_line("\"", value, "\"")
                end
            end

            if context.search_mode then
                writer:write_indent():write_line(context.search_mode:upper())
            end

            if context.global then
                writer:write_indent():write_line("GLOBAL")
            end

            if context.no_policy_scope then
                writer:write_indent():write_line("NO_POLICY_SCOPE")
            end

            if context.bypass_provider then
                writer:write_indent():write_line("BYPASS_PROVIDER")
            end

            if context.names and #context.names > 0 then
                writer:write_indent():write_line("NAMES")

                for _, value in ipairs(context.names) do
                    writer:write_indent(2):write_line("\"", value, "\"")
                end
            end

            if context.configs and #context.configs > 0 then
                writer:write_indent():write_line("CONFIGS")

                for _, value in ipairs(context.configs) do
                    writer:write_indent(2):write_line("\"", value, "\"")
                end
            end

            if context.hints and #context.hints > 0 then
                writer:write_indent():write_line("HINTS")

                for _, value in ipairs(context.hints) do
                    writer:write_indent(2):write_line("\"", value, "\"")
                end
            end

            if context.paths and #context.paths > 0 then
                writer:write_indent():write_line("PATHS")

                for _, value in ipairs(context.paths) do
                    writer:write_indent(2):write_line("\"", value, "\"")
                end
            end

            if context.registry_view then
                writer:write_indent():write_line("REGISTRY_VIEW ", context.registry_view:upper())
            end

            if context.path_suffixes and #context.path_suffixes > 0 then
                writer:write_indent():write_line("PATH_SUFFIXES")

                for _, value in ipairs(context.path_suffixes) do
                    writer:write_indent(2):write_line("\"", value, "\"")
                end
            end

            if context.no_default_path then
                writer:write_indent():write_line("NO_DEFAULT_PATH")
            end

            if context.no_package_root_path then
                writer:write_indent():write_line("NO_PACKAGE_ROOT_PATH")
            end

            

            --//TODO: finish generator action

            writer:write_line(")")
        end,
        context = self.m_config
    })
end

return class("lua-cmake.imported.package", package)
