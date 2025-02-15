---@type lfs
local lfs = require("lfs")
local utils = require("lua-cmake.utils")

---@class lua-cmake.plugins
local plugins = {}

---@private
---@param path string
function plugins.load_plugin_file(path)
    local plugin_func, load_msg = loadfile(path)
    if not plugin_func then
        cmake.fatal_error("unable to load plugin file: " .. path .. "\n" .. load_msg)
    end
    ---@cast plugin_func -nil

    local plugin_thread = coroutine.create(plugin_func)
    local success, err_msg = coroutine.resume(plugin_thread)
    if not success then
        cmake.fatal_error("error while loading plugin: " .. path .. "\n" .. debug.traceback(plugin_thread, err_msg))
    end
end

---@private
---@param path string
function plugins.load_plugin_directory(path)
    local file_path = path .. "/init.lua"
    if not lfs.exists(file_path) then
        cmake.fatal_error("unable to find plugin init file: " .. file_path)
    end

    utils.add_require_path(path, nil, nil, true)
    plugins.load_plugin_file(file_path)
end

function plugins.load()
    for _, plugin_path in pairs(cmake.config.lua_cmake.plugins) do
        local path = cmake.path_resolver.resolve_path(plugin_path, true)
        if not lfs.exists(path) then
            cmake.fatal_error("unable to find plugin: " .. path)
        end

        local package_path = package.path
        local package_cpath = package.cpath

        if lfs.attributes(path).mode == "directory" then
            plugins.load_plugin_directory(path)
        else
            plugins.load_plugin_file(path)
        end

        package.path = package_path
        package.cpath = package_cpath
    end
end

return plugins
