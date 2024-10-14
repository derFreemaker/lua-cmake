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
        func = function(writer, context)
            writer:write_line("add_library(" .. context.name .. " OBJECT")
            for _, src in ipairs(context.srcs) do
                writer:write_indent():write_line("\"" .. src .. "\"")
            end
            writer:write_line(")")
        end,
        context = self.config
    })

    cmake.registry.add_entry({
        get_name = function()
            return self.config.name
        end,

        add_srcs = function(srcs)
            for _, src in ipairs(srcs) do
                table.insert(self.config.srcs, src)
            end
        end,

        on_dep = function(entry)
            entry.add_links({ self.config.name })
        end,
    })
end

return class(kind, objects_collection)
