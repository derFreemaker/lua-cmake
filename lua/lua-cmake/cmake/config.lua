---@type lfs
local lfs = require("lfs")
local utils = require("lua-cmake.utils")
local validation = require("lua-cmake.third_party.erento.validation")

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

local config_scheme = validation.is_table({
    lua_cmake = validation.optional(
        validation.is_table({
            config = validation.optional(
                validation.is_string()),
            cmake = validation.optional(
                validation.is_string()),
            optimize = validation.optional(
                validation.is_boolean()),
            verbose = validation.optional(
                validation.is_boolean()),

            plugins = validation.optional(
                validation.is_array(validation.is_string(), false))
        }, false))
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

local valid, err = config_scheme(config)
if not valid then
    print("lua-cmake: config validation error:")

    local function print_table(t, index)
        for key, value in pairs(t) do
            if type(value) == "table" then
                print_table(value, index .. "." .. tostring(key))
                goto continue
            end
            print(index .. "." .. key .. ": " .. value)
            ::continue::
        end
    end
    print_table(err, "<config>")

    print("lua-cmake: ignoring config!")

    return default_config_copy
end

utils.table.copy_to(config, default_config_copy)
return default_config_copy
