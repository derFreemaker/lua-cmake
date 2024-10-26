local utils = require("lua-cmake.utils")
local entry_helper = require("lua-cmake.dep.entry_helper")

--//TODO: add circle dependency detection to avoid infinity loop
--//TODO: maybe build dependency tree

---@class lua-cmake.dep.registry
---@field package m_entries lua-cmake.dep.entry[]
---@field package m_resolved table<integer, true>
local registry = {
    m_entries = {}
}

---@param impl lua-cmake.dep.entry.implement
function registry.add_entry(impl)
    local entry = entry_helper.check_entry(impl)
    table.insert(registry.m_entries, entry)
end

---@return lua-cmake.dep.entry | nil
---@return integer | nil
function registry.get_entry(name)
    for index, entry in pairs(registry.m_entries) do
        if entry.impl.get_name() == name then
            return entry, index
        end
    end
end

---@private
---@return boolean has_error
function registry.resolve()
    local has_error = false

    ---@param entry lua-cmake.dep.entry
    local queue = utils.table.select(registry.m_entries, function(_, entry)
        return entry.state == "not resolved"
    end)

    local all_resolved = false
    while not all_resolved do
        all_resolved = true
        for index in pairs(queue) do
            local entry = registry.m_entries[index]
            cmake.log_verbose("resolving entry '" .. entry.impl.get_name() .. "'...")
            local entry_thread = coroutine.create(entry_helper.resolve_entry)
            local success, msg = coroutine.resume(entry_thread, entry)
            if not success then
                has_error = true
                cmake.error("when resolving entry '" .. entry.impl.get_name() .. "':\n"
                .. debug.traceback(entry_thread, msg))

                entry.state = "failed"
                queue[index] = nil
            end

            if entry.state == "resolved" then
                queue[index] = nil
            else
                all_resolved = false
            end
        end
    end

    return has_error
end

return registry
