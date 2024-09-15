---@type lua-cmake.Event
local Event = require("lua-cmake.lua.Event")
---@type lua-cmake.Logger
local Logger = require("lua-cmake.lua.Logger")
---@type lua-cmake.Task | lua-cmake.Task.Constructor
local Task = require("lua-cmake.lua.Task")

---@class lua-cmake.CMake
---@field min_version string
---@field c_std integer
---@field cxx_std integer
---@field logger lua-cmake.Logger
local CMake = {
    logger = Logger("CMake", 3)
}

local print_task = Task(
    ---@param message string
    function(message)
        print(message)
    end
)
CMake.logger.OnLog:AddTask(print_task)

---@param loglevel lua-cmake.Logger.LogLevel
function CMake:SetLogLevel(loglevel)
    self.logger:SetLogLevel(loglevel)
end

function CMake:CanUseC()
    return self.c_std ~= nil
end

function CMake:CanUseCXX()
    return self.cxx_std ~= nil
end

function CMake:Check()
    if self.min_version == nil then
        error("A minimum version of cmake needs to be specified!")
    end
end

return CMake
