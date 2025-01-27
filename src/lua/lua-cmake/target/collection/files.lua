local set = require("lua-cmake.utils.set")

---@class lua-cmake.target.collection.files.config.create
---@field name string
---@field hdrs string[] | nil
---@field srcs string[] | nil

---@class lua-cmake.target.collection.files.config
---@field name string
---@field hdrs lua-cmake.utils.set<string>
---@field srcs lua-cmake.utils.set<string>

local kind = "lua-cmake.target.collection.files"
---@class lua-cmake.target.collection.files : object
---@field config lua-cmake.target.collection.files.config
---@overload fun(config: lua-cmake.target.collection.files.config.create) : lua-cmake.target.collection.files
local files = {}

---@private
---@param config lua-cmake.target.collection.files.config.create
function files:__init(config)
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.config = config

    if self.config.hdrs then
        cmake.path_resolver.resolve_paths_implace(self.config.hdrs)
    end
    self.config.hdrs = set(self.config.hdrs)

    if self.config.srcs then
        cmake.path_resolver.resolve_paths_implace(self.config.srcs)
    end
    self.config.srcs = set(self.config.srcs)

    cmake.registry.add_entry({
        get_name = function()
            return self.config.name
        end,

        add_hdrs = function(new_hdrs)
            self.config.hdrs:add_multiple(new_hdrs)
        end,
        add_srcs = function(new_srcs)
            self.config.srcs:add_multiple(new_srcs)
        end,

        on_dep = function(entry)
            entry.add_hdrs(self.config.hdrs)
            entry.add_srcs(self.config.srcs)
        end
    })
end

return class(kind, files)
