local utils = require("lua-cmake.utils")

---@class lua-cmake.target.collection.objects.config
---@field name string
---@field srcs string[]

local kind = "lua-cmake.targets.collection.objects"
---@class lua-cmake.target.collection.objects : object
---@field config lua-cmake.target.collection.objects.config
---@overload fun(config: lua-cmake.target.collection.objects.config) : lua-cmake.target.collection.objects
local objects_collection = {}

---@private
---@param config lua-cmake.target.collection.objects.config
function objects_collection:__init(config)
    self.config = utils.table.readonly(config)

    cmake.path_resolver.resolve_paths_implace(self.config.srcs)

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
            for _, src in ipairs(srcs) do
                if utils.table.contains(self.config.srcs) then
                    goto continue
                end

                table.insert(self.config.srcs, src)

                ::continue::
            end
        end,

        on_dep = function(entry)
            entry.add_links({ self.config.name })
        end,
    })
end

return class(kind, objects_collection)
