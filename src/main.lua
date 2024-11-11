---@param lua_cmake_dir string
---@param ... string
---@return string, string[]
local function sepperate_args(lua_cmake_dir, ...)
    return lua_cmake_dir, { ... }
end
local lua_cmake_dir, args = sepperate_args(...)
lua_cmake_dir = lua_cmake_dir:gsub("\\", "/")
if lua_cmake_dir:sub(lua_cmake_dir:len()) ~= "/" then
    lua_cmake_dir = lua_cmake_dir .. "/"
end
lua_cmake_dir = lua_cmake_dir

---@return "windows" | "unix"
local function get_os()
    if package.config:sub(1, 1) == '\\' then
        return "windows"
    else
        return "unix"
    end
end

---@param path string
---@param package_path string
---@param package_cpath string
local function setup_path(path, package_path, package_cpath)
    local dynamic_lib_ext = ".so"
    if get_os() == "windows" then
        dynamic_lib_ext = ".dll"
    end

    package.path = package.path .. ";" .. path .. package_path .. "/?.lua"
    package.cpath = package.cpath .. ";" .. path .. package_cpath .. "/?" .. dynamic_lib_ext
end
setup_path(lua_cmake_dir, "src/lua", "lib")

do
    local version_file = io.open(lua_cmake_dir .. "VERSION", "r")
    if not version_file then
        error("unable to open version file!")
    end
    local version = version_file:read("l")
    print("lua-cmake version " .. version)
end

---@type boolean, lfs
local lfs_status, lfs = pcall(require, "lfs")
if not lfs_status then
    error("failed to load LuaFileSystem library:\n" .. lfs)
end
local current_dir = lfs.currentdir()
if not current_dir then
    error("was unable to get current dir.")
end

require("lua-cmake.third_party.class_system")
local cmake = require("lua-cmake.cmake")(args)

local utils = require("lua-cmake.utils")
local string_writer = require("lua-cmake.utils.string_writer")
local plugins = require("lua-cmake.plugins")

if cmake.args.force then
    cmake.log("force generating...")
end

if not lfs.exists(cmake.args.input) then
    cmake.fatal_error("config file not found: " .. cmake.args.input)
end
cmake.log_verbose("config file '" .. cmake.args.input .. "'")

-- add project_dir path to front of require paths and change working directory
utils.add_require_path(cmake.project_dir, "", "", true)
lfs.chdir(cmake.project_dir)

local stopwatch = require("lua-cmake.utils.stopwatch")
local sw_total = stopwatch()
sw_total:start()

plugins.load()

-- configure
do
    local config_func, config_err_msg = loadfile(cmake.args.input, "t")
    if not config_func then
        cmake.fatal_error("unable to load entry file: '" .. cmake.args.input .. "'\n" .. config_err_msg)
    end
    ---@cast config_func -nil

    local config_thread = coroutine.create(config_func)
    local config_success

    local sw = stopwatch()
    sw:start()

    config_success, config_err_msg = coroutine.resume(config_thread)
    if not config_success then
        cmake.fatal_error("error in config file: " .. config_err_msg .. "\n" .. debug.traceback(config_thread))
    end

    ---@diagnostic disable-next-line: invisible
    local has_error = cmake.registry.resolve()
    if has_error then
        cmake.log("dependencies resolved with error(s) (this probably will corrupt the configuration)")
    end

    sw:stop()
    cmake.log("configured (" .. sw:get_pretty_seconds() .. "s)")
end

if not cmake.get_version() then
    cmake.fatal_error("A minimum cmake version is required to be set! 'cmake.version(...)'")
end

-- optimize
if cmake.args.optimize then
    local sw = stopwatch()
    sw:start()

    ---@diagnostic disable-next-line: invisible
    local has_error = cmake.generator.optimize()
    if has_error then
        cmake.log("optimizer finished with error(s) (this probably will corrupt the configuration)")
    end

    sw:stop()
    cmake.log("optimized (" .. sw:get_pretty_seconds() .. "s)")
else
    cmake.log("optimizer disabled")
end

-- generate
do
    local sw = stopwatch()
    sw:start()

    local cmake_file = io.open(cmake.args.output, "w+")
    if not cmake_file then
        cmake.fatal_error("unable to open output file: " .. cmake.args.output)
    end
    ---@cast cmake_file -nil

    ---@param ... string
    local function write(...)
        cmake_file:write(...)
    end

    local writer = string_writer(write)

    ---@diagnostic disable-next-line: invisible
    local has_error = cmake.generator.generate(writer)
    if has_error then
        cmake.log("generator finished with error(s)")
        if not cmake.args.force then
            cmake_file:write("\nmessage(FATAL_ERROR \"lua-cmake generator failed with error(s)\")")
        end
    end

    cmake_file:close()

    sw:stop()
    cmake.log("generated (" .. sw:get_pretty_seconds() .. "s)")
end

sw_total:stop()
cmake.log("total " .. sw_total:get_pretty_seconds() .. "s")

lfs.chdir(current_dir)
