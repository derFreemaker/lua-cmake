local utils = require("lua-cmake.utils")
local set = require("lua-cmake.utils.set")

---@class lua-cmake.target.collection.objects.config.create
---@field name string
---@field srcs string[]

---@class lua-cmake.target.collection.objects.config
---@field name string
---@field srcs lua-cmake.utils.set<string>

local kind = "lua-cmake.targets.collection.objects"
---@class lua-cmake.target.collection.objects : object
---@field config lua-cmake.target.collection.objects.config
---@overload fun(config: lua-cmake.target.collection.objects.config.create) : lua-cmake.target.collection.objects
local objects_collection = {}

---@private
---@param config lua-cmake.target.collection.objects.config.create
function objects_collection:__init(config)
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.config = config

    cmake.path_resolver.resolve_paths_implace(self.config.srcs)
    self.config.srcs = set(self.config.srcs)

    cmake.generator.add_action({
        kind = kind,
        ---@param context lua-cmake.target.collection.objects.config
        func = function(builder, context)
            local name = utils.make_name_cmake_conform(context.name)
            builder:append_line("add_library(" .. name .. " OBJECT")
            for _, src in ipairs(context.srcs) do
                builder:append_indent()
                    :append_line("\"" .. src .. "\"")
            end
            builder:append_line(")")

            if not utils.is_name_cmake_conform(context.name) then
                builder:append_line("add_library(", context.name, " ALIAS ", name, ")")
            end
        end,
        context = self.config
    })

    cmake.registry.add_entry({
        get_name = function()
            return self.config.name
        end,

        add_srcs = function(srcs)
            self.config.srcs:add_multiple(srcs)
        end,

        on_dep = function(entry)
            entry.add_links({ self.config.name })
        end,
    })
end

return class(kind, objects_collection)
