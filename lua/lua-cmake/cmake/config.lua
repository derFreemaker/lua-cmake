---@type lfs
local lfs = require("lfs")
local utils = require("lua-cmake.utils")

local default_config = {
    lua_cmake = {
        default_config = "luacmake.lua",
        default_cmake = "CMakeLists.txt",
        optimize = true,
        verbose = false
    },
}

local copy = utils.table.copy(default_config)

local project_config_file = lfs.currentdir() .. "/.config/luacmake.lua"
if lfs.exists(project_config_file) then
    local success, config = pcall(function() return loadfile(project_config_file)() end)
    if not success or type(config) ~= "table" then
        print("lua-cmake: error loading config '" .. project_config_file .. "'")
    else
        utils.table.copy_to(config, copy)
    end
end

return copy
