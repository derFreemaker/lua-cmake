local utils = require("lua-cmake.third_party.utils")
---@cast utils Freemaker.utils

---@class lua-cmake.utils : Freemaker.utils
utils = utils

---@return "windows" | "unix"
function utils.get_os()
    if package.config:sub(1, 1) == '\\' then
        return "windows"
    else
        return "unix"
    end
end

---@param path string
---@param package_path string | nil
---@param package_cpath string | nil
---@param front boolean | nil
function utils.add_require_path(path, package_path, package_cpath, front)
    package_path = package_path or ""
    package_cpath = package_cpath or ""

    local dynamic_lib_ext = ".so"
    if utils.get_os() == "windows" then
        dynamic_lib_ext = ".dll"
    end

    if front then
        package.path = path .. package_path .. "/?.lua;" .. package.path
        package.cpath = path .. package_cpath .. "/?" .. dynamic_lib_ext .. ";" .. package.cpath
    else
        package.path = package.path .. ";" .. path .. package_path .. "/?.lua"
        package.cpath = package.cpath .. ";" .. path .. package_cpath .. "/?" .. dynamic_lib_ext
    end
end

---@param name string
---@return boolean
function utils.is_name_cmake_conform(name)
    if name:find(".", nil, true) then
        return false
    end

    if name:find(":", nil, true) then
        return false
    end

    return true
end

---@param name string
---@return string
function utils.make_name_cmake_conform(name)
    name = table.concat(utils.string.split(name, ".", true), "_")
    name = table.concat(utils.string.split(name, ":", true), "_")

    return name
end

return utils
