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
---@field [integer] lua-cmake.target.options.compile_option
---@field before boolean

---@class lua-cmake.target.options.include_directory
---@field items string[]
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.include_directories
---@field [integer] lua-cmake.target.options.include_directory
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

---@class lua-cmake.target_options
local target_options = {}

---@param target lua-cmake.reference<string>
---@param definitions lua-cmake.target.options.compile_definition[]
function target_options.add_target_compile_definitions(target, definitions)
    cmake.generator.add_action({
        kind = "cmake-target_compile_definitions",
        ---@param context { target: lua-cmake.reference<string>, definitions: lua-cmake.target.options.compile_definition[] }
        func = function(builder, context)
            if #context.definitions == 0 then
                return
            end

            builder:append_line("target_compile_definitions(", context.target:get())

            for _, definition in ipairs(context.definitions) do
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
        context = {
            target = target,
            definitions = definitions
        }
    })
end

---@param target lua-cmake.reference<string>
---@param features lua-cmake.target.options.compile_feature[]
function target_options.add_target_compile_features(target, features)
    cmake.generator.add_action({
        kind = "cmake-target_compile_features",
        ---@param context { target: lua-cmake.reference<string>, features: lua-cmake.target.options.compile_feature[] }
        func = function(builder, context)
            if #context.features == 0 then
                return
            end

            builder:append_line("target_compile_features(", context.target:get())

            for _, feature in ipairs(context.features) do
                builder:append_line("    ", feature.type:upper(), " ", feature.name)
            end

            builder:append_line(")")
        end,
        context = {
            target = target,
            features = features
        }
    })
end

---@param target lua-cmake.reference<string>
---@param options lua-cmake.target.options.compile_options
function target_options.add_target_compile_options(target, options)
    cmake.generator.add_action({
        kind = "cmake-target_compile_options",
        ---@param context { target: lua-cmake.reference<string>, options: lua-cmake.target.options.compile_options }
        func = function(builder, context)
            if #context.options == 0 then
                return
            end

            builder:append("target_compile_options(", context.target:get())
            if context.options.before then
                builder:append(" BEFORE")
            end
            builder:append_line()

            for _, option in ipairs(context.options) do
                builder:append("    ", option.type:upper())
                for _, item in ipairs(option.items) do
                    builder:append(" ", item)
                end
                builder:append_line()
            end

            builder:append_line(")")
        end,
        context = {
            target = target,
            options = options
        }
    })
end

---@param target lua-cmake.reference<string>
---@param options lua-cmake.target.options
function target_options.add_all_options(target, options)

end

return target_options
