local utils = require("lua-cmake.utils")

---@class lua-cmake.target.collection.srcs.config
---@field name string
---@field srcs string[]

local kind = "lua-cmake.targets.collection.srcs"
---@class lua-cmake.target.collection.srcs : object
---@field config lua-cmake.target.collection.srcs.config
local srcs_collection = {}

---@private
---@param config lua-cmake.target.collection.srcs.config
function srcs_collection:__init(config)
    self.config = utils.table.readonly(config)

    cmake.path_resolver.resolve_paths(self.config.srcs)

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
            entry.add_srcs(self.config.srcs)
        end,
    })
end

return class(kind, srcs_collection)
