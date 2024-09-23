---@class lua-cmake.target.options.compile_definition
---@field items { name: string, value: string | nil }
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
