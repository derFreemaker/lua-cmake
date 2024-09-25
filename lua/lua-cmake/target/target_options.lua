---@class lua-cmake.target_options
local target_options = {}

---@class lua-cmake.target.options.compile_definition
---@field items { name: string, value: string | nil }[]
---@field type "interface" | "private" | "public"

---@param target lua-cmake.reference<string>
---@param compile_definitions lua-cmake.target.options.compile_definition[]
function target_options.add_target_compile_definitions(target, compile_definitions)
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
            definitions = compile_definitions
        }
    })
end

---@class lua-cmake.target.options.compile_feature
---@field name string
---@field type "interface" | "private" | "public"

---@param target lua-cmake.reference<string>
---@param compile_features lua-cmake.target.options.compile_feature[]
function target_options.add_target_compile_features(target, compile_features)
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
            features = compile_features
        }
    })
end

---@class lua-cmake.target.options.compile_option
---@field items string[]
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.compile_options
---@field [integer] lua-cmake.target.options.compile_option
---@field before boolean

---@param target lua-cmake.reference<string>
---@param compile_options lua-cmake.target.options.compile_options
function target_options.add_target_compile_options(target, compile_options)
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
            options = compile_options
        }
    })
end

---@class lua-cmake.target.options.include_directory
---@field items string[]
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.include_directories
---@field [integer] lua-cmake.target.options.include_directory
---@field system boolean
---@field order "before" | "after"

---@param target lua-cmake.reference<string>
---@param include_directories lua-cmake.target.options.include_directories
function target_options.add_target_include_directories(target, include_directories)
    cmake.generator.add_action({
        kind = "cmake-target_include_directories",
        ---@param context { target: lua-cmake.reference<string>, include_directories: lua-cmake.target.options.include_directories }
        func = function (builder, context)
            if #context.include_directories == 0 then
                return
            end

            builder:append_line("target_include_directories(", context.target:get())
            for _, include_dir in ipairs(context.include_directories) do
                builder:append_line("    ", include_dir.type:upper())
                for _, dir in ipairs(include_dir.items) do
                    builder:append_line("        ", dir)
                end
            end
            builder:append_line(")")
        end,
        context = {
            target = target,
            include_directories = include_directories
        }
    })
end

---@class lua-cmake.target.options.link_directory
---@field [integer] string
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.link_directories
---@field [integer] lua-cmake.target.options.link_directory
---@field before boolean

---@param target lua-cmake.reference<string>
---@param link_directories lua-cmake.target.options.link_directories
function target_options.add_target_link_directories(target, link_directories)
    cmake.generator.add_action({
        kind = "cmake-target_link_directories",
        ---@param context { target: lua-cmake.reference<string>, link_directories: lua-cmake.target.options.link_directories }
        func = function (builder, context)
            if #context.link_directories == 0 then
                return
            end

            builder:append_line("target_link_directories(", context.target:get())
            for _, link_directory in ipairs(context.link_directories) do
                if link_directories.before then
                    builder:append_line("    BEFORE")
                end
                for _, dir in ipairs(link_directory) do
                    if link_directories.before then
                        builder:append("    ")
                    end
                    builder:append_line("    ", dir)
                end
            end
            builder:append_line(")")
        end,
        context = {
            target = target,
            link_directories = link_directories
        }
    })
end

---@param target lua-cmake.reference<string>
---@param link_libraries string[]
function target_options.add_target_link_libraries(target, link_libraries)
    cmake.generator.add_action({
        kind = "cmake-target_link_libraries",
        ---@param context { target: lua-cmake.reference<string>, link_libraries: string[] }
        func = function (builder, context)
            if #context.link_libraries == 0 then
                return
            end

            builder:append("target_link_libraries(", context.target:get())
            for _, lib in ipairs(context.link_libraries) do
                builder:append(" ", lib)
            end
            builder:append_line(")")
        end,
        context = {
            target = target,
            link_libraries = link_libraries
        }
    })
end

---@class lua-cmake.target.options.link_option
---@field [integer] string
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.link_options
---@field [integer] lua-cmake.target.options.link_option
---@field before boolean

---@param target lua-cmake.reference<string>
---@param link_options lua-cmake.target.options.link_options
function target_options.add_target_link_options(target, link_options)
    cmake.generator.add_action({
        kind = "cmake-target_link_options",
        ---@param context { target: lua-cmake.reference<string>, link_options: lua-cmake.target.options.link_options }
        func = function (builder, context)
            if #context.link_options == 0 then
                return
            end

            builder:append_line("target_link_options(", context.target:get())
            for _, link_option in ipairs(context.link_options) do
                builder:append_line("    ", link_option.type:upper())
                for _, option in ipairs(link_option) do
                    builder:append_line("       ", option)
                end
            end
            builder:append_line(")")
        end,
        context = {
            target = target,
            link_options = link_options
        }
    })
end

---@class lua-cmake.target.options.precompiled_headers
---@field [integer] string
---@field type "interface" | "private" | "public"

---@param target lua-cmake.reference<string>
---@param precompiled_headers lua-cmake.target.options.precompiled_headers
function target_options.add_target_precompiled_headers(target, precompiled_headers)
    cmake.generator.add_action({
        kind = "cmake-target_precompiled_headers",
        ---@param context { target: lua-cmake.reference<string>, precompiled_headers: lua-cmake.target.options.precompiled_headers }
        func = function (builder, context)
            if #context.precompiled_headers == 0 then
                return
            end

            builder:append_line("target_precompiled_headers(", context.target:get(), " ", context.precompiled_headers.type:upper())
            for _, precompiled_header in ipairs(context.precompiled_headers) do
                builder:append_line("    ", precompiled_header)
            end
            builder:append_line(")")
        end
    })
end

---@class lua-cmake.target.options
---@field compile_definitions lua-cmake.target.options.compile_definition[]
---@field compile_features lua-cmake.target.options.compile_feature[]
---@field compile_options lua-cmake.target.options.compile_options
---@field include_directories lua-cmake.target.options.include_directories
---@field link_directories lua-cmake.target.options.link_directories
---@field link_libraries string[]
---@field link_options lua-cmake.target.options.link_options
---@field precompiled_headers lua-cmake.target.options.precompiled_headers[]

---@param target lua-cmake.reference<string>
---@param options lua-cmake.target.options
function target_options.add_all_options(target, options)
    target_options.add_target_compile_definitions(target, options.compile_definitions)
    target_options.add_target_compile_features(target, options.compile_features)
    target_options.add_target_compile_options(target, options.compile_options)
    target_options.add_target_include_directories(target, options.include_directories)
    target_options.add_target_link_directories(target, options.link_directories)
    target_options.add_target_link_libraries(target, options.link_libraries)
    target_options.add_target_link_options(target, options.link_options)
end

return target_options
