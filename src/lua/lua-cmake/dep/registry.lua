local utils = require("lua-cmake.utils")
local entry_helper = require("lua-cmake.dep.entry_helper")

---@class lua-cmake.dep.registry
---@field private m_entries lua-cmake.dep.entry[]
local registry = {
    m_entries = {}
}

---@param impl lua-cmake.dep.entry.implement
function registry.add_entry(impl)
    local entry = entry_helper.check_entry(impl)
    table.insert(registry.m_entries, entry)
end

---@return lua-cmake.dep.entry | nil
function registry.get_entry(name)
    for _, entry in pairs(registry.m_entries) do
        if entry.impl.get_name() == name then
            return entry
        end
    end
end

---@private
---@param dep_name string
---@param reference_list string[]
function registry.check_dependency(dep_name, reference_list)
    reference_list = utils.table.copy(reference_list)
    table.insert(reference_list, dep_name)

    local dep_entry = registry.get_entry(dep_name)
    if not dep_entry then
        entry_helper.dep_not_found(dep_name, reference_list[#reference_list - 1])
    end
    ---@cast dep_entry -nil

    if dep_entry.state == "checked" or dep_entry.state == "resolved" then
        return
    end

    if dep_entry.deps_queue then
        for _, dep in ipairs(dep_entry.impl.get_deps()) do
            for entry_index, entry_name in ipairs(reference_list) do
                if dep == entry_name then
                    utils.array.drop_front_implace(reference_list, entry_index - 1)
                    table.insert(reference_list, reference_list[1])
                    cmake.fatal_error("circle dependency '" .. table.concat(reference_list, "' -> '") .. "'")
                end
            end

            registry.check_dependency(dep, reference_list)
        end
    end

    dep_entry.state = "checked"
end

---@private
function registry.check_dependencies()
    local entries = utils.array.select(registry.m_entries, function(_, entry)
        return entry.state ~= "resolved"
    end)

    for _, entry in ipairs(entries) do
        if not entry.deps_queue then
            goto continue
        end
        local entry_name = entry.impl.get_name()

        for _, dep in ipairs(entry.impl.get_deps()) do
            registry.check_dependency(dep, { entry_name })
        end

        entry.state = "checked"

        ::continue::
    end
end

---@private
---@return boolean has_error
function registry.resolve()
    registry.check_dependencies()

    ---@param entry lua-cmake.dep.entry
    local queue = utils.array.select(registry.m_entries, function(_, entry)
        return entry.state == "checked"
    end)

    local has_error = false
    while #queue ~= 0 do
        for index, entry in pairs(queue) do
            cmake.log_verbose("resolving entry '" .. entry.impl.get_name() .. "'...")
            local entry_thread = coroutine.create(entry_helper.resolve_entry)
            local success, msg = coroutine.resume(entry_thread, entry)
            if not success then
                has_error = true
                entry.state = "failed"
                queue[index] = nil

                cmake.error("when resolving entry '" .. entry.impl.get_name() .. "':\n"
                    .. debug.traceback(entry_thread, msg))
            end

            if entry.state == "resolved" then
                queue[index] = nil
            end
        end
    end

    return has_error
end

return registry
