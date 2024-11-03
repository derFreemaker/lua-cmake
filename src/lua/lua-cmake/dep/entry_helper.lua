local utils = require("lua-cmake.utils")

---@alias lua-cmake.dep.entry.state
---|"not resolved"
---|"checked"
---|"resolved"
---|"failed"

---@class lua-cmake.dep.entry.implement
---@field get_name fun() : string
---
---@field add_srcs (fun(srcs: string[])) | nil
---@field add_hdrs (fun(hdrs: string[])) | nil
---@field add_links (fun(links: string[])) | nil
---
---@field get_deps (fun() : string[]) | nil
---
---@field on_dep (fun(entry: lua-cmake.dep.entry.implement)) | nil
---
---@field custom_data table | nil

---@class lua-cmake.dep.entry
---@field impl lua-cmake.dep.entry.implement
---@field state lua-cmake.dep.entry.state
---
---@field package deps_queue string[] | nil
---@field get_deps_queue (fun() : string[]) | nil

---@class lua-cmake.dep.entry_helper
local entry_helper = {}

---@param dep_name string
---@param entry_name string
function entry_helper.dep_not_found(dep_name, entry_name)
    cmake.fatal_error("dependency '" .. dep_name .. "' not found in registry for entry: '" .. entry_name .. "'!")
end

---@param entry_data lua-cmake.dep.entry.implement
---@return lua-cmake.dep.entry
function entry_helper.check_entry(entry_data)
    if not entry_data.get_name then
        error("entry needs a '<entry>.get_name' function")
    end

    if entry_data.add_srcs and not type(entry_data.add_srcs) == "function" then
        error("'<entry>.add_srcs' can only be a function or nil")
    end

    if entry_data.add_hdrs and not type(entry_data.add_hdrs) == "function" then
        error("'<entry>.add_hrds' can only be a function or nil")
    end

    if entry_data.add_links and not type(entry_data.add_links) == "function" then
        error("'<entry>.add_links' can only be a function or nil")
    end

    if entry_data.get_deps and not type(entry_data.get_deps) == "function" then
        error("'<entry>.get_deps' can only be a function or nil")
    end

    ---@type lua-cmake.dep.entry
    local entry = {
        impl = entry_data,
        state = "not resolved",
    }

    if entry.impl.get_deps then
        entry.get_deps_queue = function()
            if not entry.deps_queue then
                entry.deps_queue = entry.impl.get_deps()
            end
            return entry.deps_queue
        end
    else
        cmake.log_verbose("entry '" .. entry.impl.get_name() .. "' has no dependencies, no resolving needed.")
        entry.state = "resolved"
    end

    return entry
end

---@param entry lua-cmake.dep.entry
function entry_helper.resolve_entry(entry)
    for index, dep in pairs(entry.get_deps_queue()) do
        cmake.log_verbose("resolving dependency '" .. dep .. "' for entry '" .. entry.impl.get_name() .. "'...")

        local dep_entry = cmake.registry.get_entry(dep)
        if not dep_entry then
            entry_helper.dep_not_found(dep, entry.impl.get_name())
        end
        ---@cast dep_entry -nil

        if dep_entry.state ~= "resolved" then
            cmake.log_verbose("dependency '" .. dep .. "' not resolved yet.")
            return
        end

        if not dep_entry.impl.on_dep then
            error("entry does is not support dependency: '" .. dep .. "'!")
        end
        dep_entry.impl.on_dep(entry.impl)

        entry.deps_queue[index] = nil
    end

    cmake.log_verbose("resolved entry '" .. entry.impl.get_name() .. "'.")
    entry.state = "resolved"
end

return entry_helper
