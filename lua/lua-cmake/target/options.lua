---@class lua-cmake.target.options.compile_definition
---@field items { [1]: string, [2]: string | nil }[]
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
---@field items string[]
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

---@class lua-cmake.target.options.precompiled_headers
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
---@field precompiled_headers lua-cmake.target.options.precompiled_headers[] | nil

---@param writer lua-cmake.utils.string_writer
---@param name string
---@param options lua-cmake.target.options | nil
return function(writer, name, options)
    if not options then
        return
    end

    if options.compile_definitions and #options.compile_definitions ~= 0 then
        writer:write_line("target_compile_definitions(", name)
        for _, definition in ipairs(options.compile_definitions) do
            writer
                :write_indent()
                :write_line(definition.type:upper())
            for _, item in pairs(definition.items) do
                writer
                    :write_indent(2)
                    :write(item[1])
                if item[2] ~= nil then
                    writer:write("=", item[2])
                end
                writer:write_line()
            end
        end
        writer:write_line(")")
    end

    if options.compile_features and #options.compile_features ~= nil then
        writer:write_line("target_compile_features(", name)
        for _, feature in ipairs(options.compile_features) do
            writer
                :write_indent()
                :write_line(feature.type:upper(), " ", feature[1])
        end
        writer:write_line(")")
    end

    if options.compile_options and #options.compile_options ~= 0 then
        writer:write("target_compile_options(", name)
        if options.compile_options.before then
            writer:write(" BEFORE")
        end
        writer:write_line()

        for _, option in ipairs(options.compile_options) do
            writer
                :write_indent()
                :write(option.type:upper())
            for _, item in ipairs(option) do
                writer:write(" ", item)
            end
            writer:write_line()
        end
        writer:write_line(")")
    end

    if options.include_directories and #options.include_directories ~= 0 then
        writer:write_line("target_include_directories(", name)
        for _, include_dir in ipairs(options.include_directories) do
            if include_dir.type then
                writer
                    :write_indent()
                    :write_line(include_dir.type:upper())
            end
            for _, dir in ipairs(include_dir.items) do
                if include_dir.type then
                    writer:write_indent()
                end
                writer
                    :write_indent()
                    :write_line(dir)
            end
        end
        writer:write_line(")")
    end

    if options.link_directories and #options.link_directories ~= 0 then
        writer:write_line("target_link_directories(", name)
        for _, link_directory in ipairs(options.link_directories) do
            if options.link_directories.before then
                writer
                    :write_indent()
                    :write_line("BEFORE")
            end
            for _, dir in ipairs(link_directory) do
                if options.link_directories.before then
                    writer:write_indent()
                end
                writer
                    :write_indent()
                    :write_line("    ", dir)
            end
        end
        writer:write_line(")")
    end

    if options.link_libraries and #options.link_libraries ~= 0 then
        writer:write_line("target_link_libraries(", name)
        for _, lib in ipairs(options.link_libraries) do
            writer:write_indent():write_line(lib)
        end
        writer:write_line(")")
    end

    if options.link_options and #options.link_options ~= 0 then
        writer:write_line("target_link_options(", name)
        for _, link_option in ipairs(options.link_options) do
            writer:write_line("    ", link_option.type:upper())
            for _, option in ipairs(link_option) do
                writer:write_line("       ", option)
            end
        end
        writer:write_line(")")
    end

    if options.precompiled_headers and #options.precompiled_headers ~= 0 then
        writer:write_line("target_precompiled_headers(", name)
        for _, precompiled_headers in ipairs(options.precompiled_headers) do
            writer:write_line("    ", precompiled_headers.type:upper())
            for _, precompiled_header in ipairs(precompiled_headers) do
                writer:write_line("        ", precompiled_header)
            end
        end
        writer:write_line(")")
    end
end
