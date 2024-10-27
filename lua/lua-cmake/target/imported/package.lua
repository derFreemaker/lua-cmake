local utils = require("lua-cmake.utils")

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

local kind = "cmake.find_package"
---@class lua-cmake.imported.package : object
---@field private m_config lua-cmake.imported.package.config
---@overload fun(config: lua-cmake.imported.package.config, imports: string[] | nil) : lua-cmake.imported.package
local package = {}

---@private
---@param config lua-cmake.imported.package.config
---@param imports string[] | nil
function package:__init(config, imports)
    self.m_config = config

    cmake.generator.add_action({
        kind = kind,
        ---@param context lua-cmake.imported.package.config
        func = function(builder, context)
            builder:append_line("find_package(", context.name)
                :modify_indent(1)

            if context.version then
                builder:append_line(context.version)
            end

            if context.exact then
                builder:append_line("EXACT")
            end

            if context.quiet then
                builder:append_line("QUIET")
            end

            if context.required then
                builder:append_line("REQUIRED")
            end

            if context.components and #context.components > 0 then
                builder:append_line("COMPONENTS")

                for _, value in ipairs(context.components) do
                    builder:append_indent()
                        :append_line("\"", value, "\"")
                end
            end

            if context.optional_components and #context.optional_components > 0 then
                builder:append_line("OPTIONAL_COMPONENTS")

                for _, value in ipairs(context.optional_components) do
                    builder:append_indent()
                        :append_line("\"", value, "\"")
                end
            end

            if context.search_mode then
                builder:append_line(context.search_mode:upper())
            end

            if context.global then
                builder:append_line("GLOBAL")
            end

            if context.no_policy_scope then
                builder:append_line("NO_POLICY_SCOPE")
            end

            if context.bypass_provider then
                builder:append_line("BYPASS_PROVIDER")
            end

            if context.names and #context.names > 0 then
                builder:append_line("NAMES")

                for _, value in ipairs(context.names) do
                    builder:append_indent()
                        :append_line("\"", value, "\"")
                end
            end

            if context.configs and #context.configs > 0 then
                builder:append_line("CONFIGS")

                for _, value in ipairs(context.configs) do
                    builder:append_indent()
                        :append_line("\"", value, "\"")
                end
            end

            if context.hints and #context.hints > 0 then
                builder:append_line("HINTS")

                for _, value in ipairs(context.hints) do
                    builder:append_indent()
                        :append_line("\"", value, "\"")
                end
            end

            if context.paths and #context.paths > 0 then
                builder:append_line("PATHS")

                for _, value in ipairs(context.paths) do
                    builder:append_indent()
                        :append_line("\"", value, "\"")
                end
            end

            if context.registry_view then
                builder:append_line("REGISTRY_VIEW ", context.registry_view:upper())
            end

            if context.path_suffixes and #context.path_suffixes > 0 then
                builder:append_line("PATH_SUFFIXES")

                for _, value in ipairs(context.path_suffixes) do
                    builder:append_indent()
                        :append_line("\"", value, "\"")
                end
            end

            if context.no_default_path then
                builder:append_line("NO_DEFAULT_PATH")
            end

            if context.no_package_root_path then
                builder:append_line("NO_PACKAGE_ROOT_PATH")
            end

            if context.no_cmake_path then
                builder:append_line("NO_CMAKE_PATH")
            end

            if context.no_cmake_environment_path then
                builder:append_line("NO_CMAKE_ENVIRONMENT_PATH")
            end

            if context.no_system_environment_path then
                builder:append_line("NO_SYSTEM_ENVIRONMENT_PATH")
            end

            if context.no_cmake_package_registry then
                builder:append_line("NO_CMAKE_PACKAGE_REGISTRY")
            end

            if context.no_cmake_system_path then
                builder:append_line("NO_CMAKE_SYSTEM_PATH")
            end

            if context.no_cmake_install_prefix then
                builder:append_line("NO_CMAKE_INSTALL_PREFIX")
            end

            if context.no_cmake_system_package_registry then
                builder:append_line("NO_CMAKE_SYSTEM_PACKAGE_REGISTRY")
            end

            if context.cmake_find_root_path then
                if context.cmake_find_root_path == "both" then
                    builder:append_line("CMAKE_FIND_ROOT_PATH_BOTH")
                elseif context.cmake_find_root_path == "only" then
                    builder:append_line("ONLY_CMAKE_FIND_ROOT_PATH")
                else
                    builder:append_line("NO_CMAKE_FIND_ROOT_PATH")
                end
            end

            builder:modify_indent(-1)
                :append_line(")")
        end,
        context = self.m_config
    })

    if imports then
        for _, import in ipairs(imports) do
            cmake.registry.add_entry({
                get_name = function()
                    return import
                end,

                on_dep = function(entry)
                    entry.add_links({ import })
                end,
            })
        end
    end
end

return class("lua-cmake.imported.package", package)
