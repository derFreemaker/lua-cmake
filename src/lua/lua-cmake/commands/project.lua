local project = require("lua-cmake.project")

---@class lua-cmake
local cmake = _G.cmake

---@param config lua-cmake.project.config
function cmake.project(config)
    return project(config)
end
