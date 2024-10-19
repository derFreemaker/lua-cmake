---@class lua-cmake.target.collection.files.config
---@field name string
---@field hdrs string[] | nil
---@field srcs string[] | nil

local kind = "lua-cmake.target.collection.files"
---@class lua-cmake.target.collection.files : object
---@field config lua-cmake.target.collection.files.config
---@overload fun(config: lua-cmake.target.collection.files.config) : lua-cmake.target.collection.files
local files = {}

---@private
---@param config lua-cmake.target.collection.files.config
function files:__init(config)
    self.config = config

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

    cmake.registry.add_entry({
        get_name = function()
            return self.config.name
        end,

        add_hdrs = function(new_hdrs)
            for _, hdr in ipairs(new_hdrs) do
                table.insert(self.config.hdrs, hdr)
            end
        end,
        add_srcs = function(new_srcs)
            for _, src in ipairs(new_srcs) do
                table.insert(self.config.srcs, src)
            end
        end,

        on_dep = function(entry)
            if entry.add_hdrs then
                entry.add_hdrs(self.config.hdrs)
            end

            if entry.add_srcs then
                entry.add_srcs(self.config.srcs)
            end
        end
    })
end

return class(kind, files)
