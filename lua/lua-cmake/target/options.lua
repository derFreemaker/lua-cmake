---@class lua-cmake.target.options.compile_definition
---@field [integer] { [1]: string, [2]: string | nil }
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.compile_feature
---@field [1] string
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.compile_option
---@field [integer] string
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.compile_options
---@field [integer] lua-cmake.target.options.compile_option
---@field before boolean | nil

---@class lua-cmake.target.options.include_directory
---@field [integer] string
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.include_directories
---@field [integer] lua-cmake.target.options.include_directory
---@field system boolean | nil
---@field order "before" | "after" | nil

---@class lua-cmake.target.options.link_directory
---@field [integer] string
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.link_directories
---@field [integer] lua-cmake.target.options.link_directory
---@field before boolean | nil

---@class lua-cmake.target.options.link_option
---@field [integer] string
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options.link_options
---@field [integer] lua-cmake.target.options.link_option
---@field before boolean | nil

---@class lua-cmake.target.options.precompile_headers
---@field [integer] string
---@field type "interface" | "private" | "public"

---@class lua-cmake.target.options
---@field compile_definitions lua-cmake.target.options.compile_definition[] | nil
---@field compile_features lua-cmake.target.options.compile_feature[] | nil
---@field compile_options lua-cmake.target.options.compile_options | nil
---@field include_directories lua-cmake.target.options.include_directories | nil
---@field link_directories lua-cmake.target.options.link_directories | nil
---@field link_libraries string[] | nil
---@field link_options lua-cmake.target.options.link_options | nil
---@field precompile_headers lua-cmake.target.options.precompile_headers[] | string[] | nil

--//TODO: rewrite options generation to allow validation

---@param builder lua-cmake.utils.string_builder
---@param target string
---@param options lua-cmake.target.options
---@param is_interface boolean | nil
return function(builder, target, options, is_interface)
    if is_interface then
        target = target .. " INTERFACE"
    end

    if options.compile_definitions and #options.compile_definitions ~= 0 then
        builder:append_line("target_compile_definitions(", target)
        for _, definition in ipairs(options.compile_definitions) do
            builder:append_indent()
                :append_line(definition.type:upper())
            for _, item in ipairs(definition) do
                builder:append_indent(2)
                    :append(item[1])
                if item[2] ~= nil then
                    builder:append("=", item[2])
                end
                builder:append_line()
            end
        end
        builder:append_line(")")
    end

    if options.compile_features and #options.compile_features ~= nil then
        builder:append_line("target_compile_features(", target)
        for _, feature in ipairs(options.compile_features) do
            builder:append_indent()
                :append_line(feature.type:upper(), " ", feature[1])
        end
        builder:append_line(")")
    end

    if options.compile_options and #options.compile_options ~= 0 then
        builder:append("target_compile_options(", target)
        if options.compile_options.before then
            builder:append(" BEFORE")
        end
        builder:append_line()

        for _, option in ipairs(options.compile_options) do
            builder:append_indent()
                :append(option.type:upper())
            for _, item in ipairs(option) do
                builder:append(" ", item)
            end
            builder:append_line()
        end
        builder:append_line(")")
    end

    if options.include_directories and #options.include_directories ~= 0 then
        builder:append_line("target_include_directories(", target)
        for _, include_dir in ipairs(options.include_directories) do
            if include_dir.type then
                builder:append_indent()
                    :append_line(include_dir.type:upper())
            end
            for _, dir in ipairs(include_dir) do
                if include_dir.type then
                    builder:append_indent()
                end
                builder:append_indent()
                    :append_line(dir)
            end
        end
        builder:append_line(")")
    end

    if options.link_directories and #options.link_directories ~= 0 then
        builder:append_line("target_link_directories(", target)
        for _, link_directory in ipairs(options.link_directories) do
            if options.link_directories.before then
                builder:append_indent()
                    :append_line("BEFORE")
            end
            for _, dir in ipairs(link_directory) do
                if options.link_directories.before then
                    builder:append_indent()
                end
                builder:append_indent()
                    :append_line("    ", dir)
            end
        end
        builder:append_line(")")
    end

    if options.link_libraries and #options.link_libraries ~= 0 then
        builder:append_line("target_link_libraries(", target)
        for _, lib in ipairs(options.link_libraries) do
            builder:append_indent()
                :append_line(lib)
        end
        builder:append_line(")")
    end

    if options.link_options and #options.link_options ~= 0 then
        builder:append_line("target_link_options(", target)
        for _, link_option in ipairs(options.link_options) do
            builder:append_indent()
                :append_line(link_option.type:upper())
            for _, option in ipairs(link_option) do
                builder:append_indent(2)
                    :append_line(option)
            end
        end
        builder:append_line(")")
    end

    if options.precompile_headers and #options.precompile_headers ~= 0 then
        builder:append_line("target_precompile_headers(", target)
        for _, precompiled_headers in ipairs(options.precompile_headers) do
            if type(precompiled_headers) == "table" then
                builder:modify_indent(1)
                    :append_line(precompiled_headers.type:upper())
                for _, precompiled_header in ipairs(precompiled_headers) do
                    builder:append_indent()
                        :append_line(precompiled_header)
                end
                builder:modify_indent(-1)
            else
                builder:append_indent()
                    :append_line(precompiled_headers)
            end
        end
        builder:append_line(")")
    end
end
