---@type lfs
local lfs = require("lfs")
local utils = require("lua-cmake.utils")
local validation = require("lua-cmake.validation")

---@class lua-cmake.config
---@field config string
---@field cmake string
---@field optimize boolean
---@field verbose boolean
---@field plugins string[]

local default_config = {
    lua_cmake = {
        config = "luacmake.lua",
        cmake = "CMakeLists.txt",
        optimize = true,
        verbose = false,

        plugins = {}
    },
}
local default_config_copy = utils.table.copy(default_config)

local config_validator = validation.is_table({
    lua_cmake = validation.optional.is_table({
        config = validation.optional.is_string(),
        cmake = validation.optional.is_string(),
        optimize = validation.optional.is_boolean(),
        verbose = validation.optional.is_boolean(),

        plugins = validation.optional.is_array(
            validation.is_string()),
    })
}, true)

local project_config_file = lfs.currentdir() .. "/.config/luacmake.lua"
if not lfs.exists(project_config_file) then
    return default_config_copy
end

local success, config = pcall(function() return loadfile(project_config_file)() end)
if not success then
    print("lua-cmake: error loading config: " .. project_config_file)
    return default_config_copy
end

local valid, err = config_validator(config)
if not valid then
    ---@cast err -nil

    print("lua-cmake: config validation error:")
    print(err.to_string())
    print("lua-cmake: ignoring config!")

    return default_config_copy
end

utils.table.copy_to(config, default_config_copy)
return default_config_copy
