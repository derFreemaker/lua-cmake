---@class lua-cmake.Registry
---@field m_targets lua-cmake.Target[]
local Registry = {
    m_targets = {}
}

---@param targetName string
---@return boolean success
---@return lua-cmake.Target | nil value
function Registry:ExistsTarget(targetName)
    for _, value in ipairs(self.m_targets) do
        if value:GetName() == targetName then
            return true, value
        end
    end
    return false, nil
end

---@param target lua-cmake.Target
function Registry:AddTarget(target)
    self.m_targets[target:GetName()] = target
end

return Registry
