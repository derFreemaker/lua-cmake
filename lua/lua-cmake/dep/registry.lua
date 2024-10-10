local entry_helper = require("lua-cmake.dep.entry_helper")

---@class lua-cmake.dep.registry
---@field package m_entries lua-cmake.dep.entry[]
---@field package m_resolved table<integer, true>
local registry = {
    m_entries = {}
}

---@param entry lua-cmake.dep.entry
function registry.add_entry(entry)
    entry_helper.check_entry(entry)
    table.insert(registry.m_entries, entry)
end

---@return lua-cmake.dep.entry | nil
---@return integer | nil
function registry.get_entry(name)
    for index, entry in pairs(registry.m_entries) do
        if entry.get_name() == name then
            return entry, index
        end
    end
end

---@private
---@return boolean has_error
function registry.resolve()
    local has_error = false

    local all_resolved = false
    while not all_resolved do
        all_resolved = true
        for _, entry in ipairs(registry.m_entries) do
            if entry.is_resolved then
                goto continue
            end

            local entry_thread = coroutine.create(entry_helper.resolve_entry)
            local success, msg = coroutine.resume(entry_thread, entry)
            if not success then
                has_error = true
                print("lua-cmake: error when resolving entry '" .. entry.get_name() .. "':\n"
                    .. debug.traceback(entry_thread, msg))
            end

            if not entry.is_resolved then
                all_resolved = false
            end

            ::continue::
        end
    end

    return has_error
end

return registry
