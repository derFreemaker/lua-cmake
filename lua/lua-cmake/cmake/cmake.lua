---@class lua-cmake.cmake
---@field m_cmake_version string
---@field m_registry lua-cmake.registry
local cmake = {
    m_registry = require("lua-cmake.cmake.registry"),
}

---@param version string?
---@return string
function cmake.cmake_minimum_required(version)
    if version == nil then
        return cmake.m_cmake_version
    end

    cmake.m_cmake_version = version
    return version
end

return cmake
