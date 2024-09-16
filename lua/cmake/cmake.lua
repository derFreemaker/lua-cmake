---@class lua-cmake.CMake
---@field min_version string
---@field c_std integer
---@field cxx_std integer
local CMake = {}

---@param version string
function CMake:MinVersion(version)
    self.min_version = version
end

---@param version integer
function CMake:STD_C(version)
    self.c_std = version
end

---@param version integer
function CMake:STD_CXX(version)
    self.cxx_std = version
end

function CMake:Check()
    if self.min_version == nil then
        error("A minimum version of cmake needs to be specified!")
    end
end

return CMake
