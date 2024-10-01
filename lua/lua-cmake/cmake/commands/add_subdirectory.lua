---@type lfs
local lfs = require("lfs")

---@class lua-cmake.cmake
local cmake = _G.cmake

---@param source_dir string
---@param file_name string | nil without the extension
function cmake.add_subdirectory(source_dir, file_name)
    local current = lfs.currentdir()
    if not current then
        error("unable to get current directory")
    end

    file_name = file_name or "luacmake"

    lfs.chdir(source_dir)
    require(file_name)
    lfs.chdir(current)
end
