local utils = require("lua-cmake.utils")

---@class lua-cmake.target.interface.config
---@field name string
---@field hdrs string[] | nil
---@field srcs string[] | nil
---@field deps string[] | nil

local kind = "lua-cmake.target.interface"
---@class lua-cmake.target.interface : object
---@field config lua-cmake.target.interface.config
---@field links string[]
---@overload fun(config: lua-cmake.target.interface.config) : lua-cmake.target.interface
local interface = {}

---@private
---@param config lua-cmake.target.interface.config
function interface:__init(config)
    self.config = config
    self.links = {}

    if self.config.hdrs then
        cmake.path_resolver.resolve_paths_implace(self.config.hdrs)
    else
        self.config.hdrs = {}
    end

    if self.config.srcs then
        cmake.path_resolver.resolve_paths_implace(self.config.srcs)
    else
        self.config.srcs = {}
    end

    if not self.config.deps then
        self.config.deps = {}
    end

    cmake.registry.add_entry({
        get_name = function()
            return self.config.name
        end,

        get_deps = function()
            return self.config.deps
        end,

        add_hdrs = function(hdrs)
            for _, hdr in ipairs(hdrs) do
                if utils.table.contains(self.config.hdrs, hdr) then
                    goto continue
                end

                table.insert(self.config.hdrs, hdr)

                ::continue::
            end
        end,
        add_srcs = function(srcs)
            for _, src in ipairs(srcs) do
                if utils.table.contains(self.config.srcs, src) then
                    goto continue
                end

                table.insert(self.config.srcs, src)

                ::continue::
            end
        end,
        add_links = function(links)
            for _, link in ipairs(links) do
                if utils.table.contains(self.links, link) then
                    goto continue
                end

                table.insert(self.links, link)

                ::continue::
            end
        end,

        on_dep = function(entry)
            if entry.add_hdrs then
                entry.add_hdrs(self.config.hdrs)
            end

            if entry.add_srcs then
                entry.add_srcs(self.config.srcs)
            end

            if entry.add_links then
                entry.add_links(self.links)
            end
        end
    })
end

return class(kind, interface)
