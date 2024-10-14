local utils = require("lua-cmake.third_party.derFreemaker.utils")
---@cast utils Freemaker.utils

---@class lua-cmake.utils : Freemaker.utils
utils = utils

---@return "windows" | "linux"
function utils.get_os()
    if package.config:sub(1, 1) == '\\' then
        return "windows"
    else
        return "linux"
    end
end

---@param path string
---@param package_path string
---@param package_cpath string
function utils.setup_path(path, package_path, package_cpath)
    local dynamic_lib_ext = ".so"
    if utils.get_os() == "windows" then
        dynamic_lib_ext = ".dll"
    end

    package.path = package.path .. ";" .. path .. package_path .. "/?.lua"
    package.cpath = package.cpath .. ";" .. path .. package_cpath .. "/?" .. dynamic_lib_ext
end

return utils
