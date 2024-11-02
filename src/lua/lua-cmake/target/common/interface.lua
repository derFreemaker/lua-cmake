local set = require("lua-cmake.utils.set")

---@class lua-cmake.target.common.interface.config.create
---@field name string
---@field hdrs string[] | nil
---@field srcs string[] | nil
---@field exclude_from_all boolean | nil
---
---@field deps string[] | nil

---@class lua-cmake.target.common.interface.config
---@field name string
---@field hdrs lua-cmake.utils.set<string>
---@field srcs lua-cmake.utils.set<string>
---@field exclude_from_all boolean | nil
---
---@field deps lua-cmake.utils.set<string>

local kind = "lua-cmake.target.interface"
---@class lua-cmake.target.common.interface : object
---@field config lua-cmake.target.common.interface.config
---@field links lua-cmake.utils.set<string>
---@overload fun(config: lua-cmake.target.common.interface.config.create) : lua-cmake.target.common.interface
local interface = {}

---@private
---@param config lua-cmake.target.common.interface.config.create
function interface:__init(config)
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.config = config
    self.links = set()

    if self.config.hdrs then
        cmake.path_resolver.resolve_paths_implace(self.config.hdrs)
    end
    self.config.hdrs = set(self.config.hdrs)

    if self.config.srcs then
        cmake.path_resolver.resolve_paths_implace(self.config.srcs)
    end
    self.config.srcs = set(self.config.srcs)

    self.config.deps = set(self.config.deps)

    cmake.registry.add_entry({
        get_name = function()
            return self.config.name
        end,

        add_hdrs = function(hdrs)
            self.config.hdrs:add_multiple(hdrs)
        end,
        add_srcs = function(srcs)
            self.config.srcs:add_multiple(srcs)
        end,
        add_links = function(links)
            self.links:add_multiple(links)
        end,

        on_dep = function(entry)
            entry.add_hdrs(self.config.hdrs:get())
            entry.add_srcs(self.config.srcs:get())
            entry.add_links(self.links:get())
        end,

        get_deps = function()
            return self.config.deps:get()
        end,
    })
end

return class(kind, interface)
