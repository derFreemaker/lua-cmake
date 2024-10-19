local utils = require("lua-cmake.utils")

---@class lua-cmake.dep.entry
---@field get_name fun() : string
---
---@field add_srcs (fun(srcs: string[])) | nil
---@field add_hdrs (fun(hdrs: string[])) | nil
---@field add_links (fun(links: string[])) | nil
---
---@field get_deps (fun() : string[]) | nil
---
---@field data table | nil
---
---@field is_resolved boolean | nil
---@field package on_dep (fun(entry: lua-cmake.dep.entry)) | nil

---@class lua-cmake.dep.entry_helper
local entry_helper = {}

---@param entry lua-cmake.dep.entry
function entry_helper.check_entry(entry)
    if not entry.get_name then
        error("entry needs a '<entry>.get_name' function")
    end

    if entry.add_srcs and not type(entry.add_srcs) == "function" then
        error("'<entry>.add_srcs' can only be a function or nil")
    end

    if entry.add_hdrs and not type(entry.add_hdrs) == "function" then
        error("'<entry>.add_hrds' can only be a function or nil")
    end

    if entry.add_links and not type(entry.add_links) == "function" then
        error("'<entry>.add_links' can only be a function or nil")
    end

    if entry.get_deps and not type(entry.get_deps) == "function" then
        error("'<entry>.get_deps' can only be a function or nil")
    end
end

---@param entry lua-cmake.dep.entry
function entry_helper.resolve_entry(entry)
    if entry.get_deps then
        for _, dep in ipairs(entry.get_deps()) do
            local dep_entry = cmake.registry.get_entry(dep)
            if not dep_entry then
                cmake.fatal_error("dependency '" .. dep .. "' not found in registry for entry: '" .. entry.get_name() .. "'")
            end
            ---@cast dep_entry -nil

            if not dep_entry.is_resolved then
                return
            end

            if not dep_entry.on_dep then
                error("entry does is not support dependency: '" .. dep .. "'")
            end
            dep_entry.on_dep(entry)
        end
    end

    entry.is_resolved = true
end

return entry_helper
