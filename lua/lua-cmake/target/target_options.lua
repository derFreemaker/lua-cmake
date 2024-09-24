---@class lua-cmake.target.options.compile_definition
---@field items { name: string, value: string | nil }[]
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.compile_feature
---@field name string
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.compile_option
---@field items string[]
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.compile_options
---@field options lua-cmake.target.options.compile_option[]
---@field before boolean

---@class lua-cmake.target.options.include_directory
---@field items string[]
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.include_directories
---@field directories lua-cmake.target.options.include_directory[]
---@field system boolean
---@field order "before" | "after"

---@class lua-cmake.target.options.link_directory
---@field directories string[]
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.link_directories
---@field directories lua-cmake.target.options.link_directory[]
---@field before boolean

---@class lua-cmake.target.options.link_option
---@field items string[]
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.link_options
---@field options lua-cmake.target.options.link_option[]
---@field before boolean

---@class lua-cmake.target.options.precompiled_headers
---@field headers string[]
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options
---@field compile_definitions lua-cmake.target.options.compile_definition[]
---@field compile_features lua-cmake.target.options.compile_feature[]
---@field compile_options lua-cmake.target.options.compile_options
---@field include_directories lua-cmake.target.options.include_directories
---@field link_directories lua-cmake.target.options.link_directories
---@field link_libraries string[]
---@field link_options lua-cmake.target.options.link_options
---@field precompiled_headers lua-cmake.target.options.precompiled_headers[]

---@class lua-cmake.target.config
---@field name string
---@field options lua-cmake.target.options

---@param config lua-cmake.target.config
local function add_target_options(config)
    cmake.generator.add_action({
        kind = "cmake-target_compile_definitions",
        ---@param context lua-cmake.target.config
        func = function(builder, context)
            if #context.options.compile_definitions == 0 then
                return
            end

            builder:append_line("target_compile_definitions(", context.name)

            for _, definition in ipairs(context.options.compile_definitions) do
                builder:append_line("    ", definition.type:upper())
                for _, item in pairs(definition.items) do
                    builder:append("        ", item.name)
                    if item.value ~= nil then
                        builder:append("=", item.value)
                    end
                    builder:append_line()
                end
            end
            builder:append_line(")")
        end,
        context = config
    })

    cmake.generator.add_action({
        kind = "cmake-target_compile_features",
        ---@param context lua-cmake.target.config
        func = function(builder, context)
            if #context.options.compile_features == 0 then
                return
            end

            builder:append_line("target_compile_features(", context.name)

            for _, feature in ipairs(context.options.compile_features) do
                builder:append_line("    ", feature.type:upper(), " ", feature.name)
            end

            builder:append_line(")")
        end,
        context = config
    })

    cmake.generator.add_action({
        kind = "cmake-target_compile_options",
        ---@param context lua-cmake.target.config
        func = function(builder, context)
            if #context.options.compile_options == 0 then
                return
            end

            builder:append("target_compile_options(", context.name)
            if context.options.compile_options.before then
                builder:append(" BEFORE")
            end
            builder:append_line()

            for _, option in ipairs(context.options.compile_options.options) do
                builder:append("    ", option.type:upper())
                for _, item in ipairs(option.items) do
                    builder:append(" ", item)
                end
                builder:append_line()
            end

            builder:append_line(")")
        end,
        context = config
    })
end

return add_target_options
