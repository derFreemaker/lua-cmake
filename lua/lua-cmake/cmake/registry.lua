local ClassSystem = require("lua-cmake.third_party.derFreemaker.ClassSystem")

---@alias lua-cmake.generator fun(target: lua-cmake.target) : string

---@class lua-cmake.registry
---@field m_targets_order string[]
---@field m_targets table<string, lua-cmake.target>
local registry = {
    m_targets_order = {},
    m_targets = {},
}

---@nodiscard
---@return lua-cmake.target[]
function registry:get_targets_inorder()
    ---@type lua-cmake.target[]
    local targets = {}
    for _, name in ipairs(self.m_targets_order) do
        table.insert(targets, self.m_targets[name])
    end
    return targets
end

---@nodiscard
---@param target_name string
---@return lua-cmake.target
function registry:get_target(target_name)
    return self.m_targets[target_name]
end

---@param target lua-cmake.target
function registry:add_target(target)
    if not ClassSystem.HasInterface(target, "lua-cmake.target") then
        error("can not add target that does not have interface: lua-cmake.target")
    end

    local target_name = target:get_name()
    if self:get_target(target_name) then
        error("target already exists: " .. target_name)
    end

    table.insert(self.m_targets_order, target_name)
    self.m_targets[target_name] = target
end

---@return boolean
function registry:check()
    local good = true
    -- for target_name, target in pairs(self.m_targets) do
    --     for _, dep_name in ipairs(target:get_deps()) do
    --         if not self:get_target(dep_name) then
    --             print("dependency: '" .. dep_name .. "' from target: '" .. target_name .. "' could not be found")
    --             return false
    --         end
    --     end
    -- end
    return good
end

return registry
