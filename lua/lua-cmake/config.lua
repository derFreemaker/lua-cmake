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

        plugins = validation.optional.is_array(validation.is_string()),
    })
}, true)

---@param config_path string
return function(config_path)
    if not lfs.exists(config_path) then
        return default_config_copy
    end

    local config_file_env = _ENV
    config_file_env.config = default_config_copy
    local success, config = pcall(function() return loadfile(config_path)() end)
    if not success then
        cmake.fatal_error("loading config: " .. config_path)
    end

    local valid, err = config_validator:validate(config)
    if not valid then
        ---@cast err -nil
        cmake.fatal_error("config validation error:\n" .. err.to_string())
    end

    utils.table.copy_to(config, default_config_copy)
    return default_config_copy
end
