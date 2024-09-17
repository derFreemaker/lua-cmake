---@class lua-cmake.CMake
---@field m_cmake_version string
---@field m_registry lua-cmake.registry
local CMake = {
    m_registry = require("lua-cmake.cmake.registry"),
}

---@param version string?
---@return string
function CMake:cmake_version(version)
    if version == nil then
        return self.m_cmake_version
    end

    self.m_cmake_version = version
    return version
end

return CMake
