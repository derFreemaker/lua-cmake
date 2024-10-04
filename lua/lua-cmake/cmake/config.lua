local lfs = require("lfs")
local utils = require("lua-cmake.third_party.derFreemaker.utils.bin.utils")

local default_config = {
    lua_cmake = {
        default_config = "luacmake.lua",
        default_cmake = "CMakeLists.txt",
        optimize = true
    },
}

---@param lua_cmake_dir string
---@return table
return function(lua_cmake_dir)
    local global_config_file = lua_cmake_dir .. "bin/lua-cmake.conf.lua"
    local config
    if lfs.exists(global_config_file) then
        local success
        success, config = pcall(function() return loadfile(global_config_file)() end)
        if not success or type(config) ~= "table" then
            print("lua-cmake: error loading config '" .. global_config_file .. "' (should return a table)")
            return default_config
        end
    end

    local modified = utils.table.copy(default_config)
    utils.table.copy_to(config, modified)

    return modified
end
