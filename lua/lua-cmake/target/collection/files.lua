
local kind = "lua-cmake.target.collection.files"
---@class lua-cmake.target.collection.files : object
---@field name string
---@field srcs string[]
---@field hdrs string[]
---@overload fun(name: string, hrds: string[] | nil, srcs: string[] | nil) : lua-cmake.target.collection.files
local files = {}

---@private
---@param name string
---@param hdrs string[] | nil
---@param srcs string[] | nil
function files:__init(name, hdrs, srcs)
    self.name = name
    self.hdrs = hdrs or {}
    self.srcs = srcs or {}

    cmake.registry.add_entry({
        get_name = function()
            return self.name
        end,

        add_hdrs = function(new_hdrs)
            for _, hdr in ipairs(new_hdrs) do
                table.insert(self.hdrs, hdr)
            end
        end,
        add_srcs = function(new_srcs)
            for _, src in ipairs(new_srcs) do
                table.insert(self.srcs, src)
            end
        end,

        on_dep = function(entry)
            if entry.add_hdrs then
                entry.add_hdrs(self.hdrs)
            end

            if entry.add_srcs then
                entry.add_srcs(self.srcs)
            end
        end
    })
end

return class(kind, files)
