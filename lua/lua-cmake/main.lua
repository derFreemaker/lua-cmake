local lua_cmake_dir = os.getenv("LUA_CMAKE_DIR")
if lua_cmake_dir == nil then
    error("LUA_CMAKE_DIR env variable not defined. Is needed for loading libraries.")
end
lua_cmake_dir = lua_cmake_dir:gsub("\\", "/")
if lua_cmake_dir:sub(lua_cmake_dir:len()) ~= "/" then
    lua_cmake_dir = lua_cmake_dir .. "/"
end

---@return "windows" | "linux"
local function get_os()
    if package.config:sub(1, 1) == '\\' then
        return "windows"
    else
        return "linux"
    end
end

---@param path string
---@param relative string
---@return string
local function make_path_absolute(path, relative)
    local new_path

    if get_os() == "windows" then
        local str = path:sub(2, 2)
        if str == ":" then
            new_path = path
        else
            new_path = relative .. "/" .. path
        end
        new_path = new_path:gsub("\\", "/")
    else
        if path:sub(1, 1) == "/" then
            new_path = path
        else
            new_path = relative .. "/" .. path
        end
    end

    return new_path
end

local function setup_path()
    local dynamic_lib_ext = ".so"
    if get_os() == "windows" then
        dynamic_lib_ext = ".dll"
    end

    package.path = package.path .. ";" .. lua_cmake_dir .. "lua/?.lua"
    package.cpath = package.cpath .. ";" .. lua_cmake_dir .. "lib/?" .. dynamic_lib_ext
end
setup_path()

---@type boolean, lfs
local lfs_status, lfs = pcall(require, "lfs")
if not lfs_status then
    error("Failed to load LuaFileSystem library: " .. lfs)
end
require("lua-cmake.third_party.derFreemaker.class_system")

local cli_parser = require("lua.lua-cmake.third_party.mpeterv.cli_parser")
local string_writer = require("lua-cmake.utils.string_writer")
require("lua-cmake.cmake.cmake")
cmake.config = require("lua-cmake.cmake.config")(lua_cmake_dir)

local parser = cli_parser("lua-cmake", "Used to generate cmake files configured from lua.")
parser:argument("config", "The config file for lua-cmake.", cmake.config.lua_cmake.default_config)
parser:option("-o --output", "The output file path in which the generate cmake gets written to.", cmake.config.lua_cmake.default_cmake)
parser:option("-p --optimize", "Sets the optimizer should NOT be run. (Disabling can improve stability)", cmake.config.lua_cmake.optimize)

---@type { config: string, output: string | nil, optimize: boolean }
local args = parser:parse()

--//TODO: add version flag

do
    local current_dir = lfs.currentdir()
    if not current_dir then
        error("unable to get current directory")
    end

    args.config = make_path_absolute(args.config, current_dir)
    args.output = make_path_absolute(args.output, current_dir)

    do
        local reverse = args.config:reverse()
        local pos = reverse:find("/", reverse:find("/", nil, true), true)
        local parent_folder = args.config:sub(0, reverse:len() - pos)
        lfs.chdir(parent_folder)
    end
end

if not lfs.exists(args.config) then
    error("config file not found: " .. args.config)
end
print("lua-cmake: config file '" .. args.config .. "'")

local stopwatch = require("lua-cmake.utils.stopwatch")
local sw_total = stopwatch()
sw_total:start()

do
    local config_func, config_err_msg = loadfile(args.config, "t")
    if not config_func then
        error("unable to load entry file: '" .. args.config .. "' \nerror:\n  " .. config_err_msg)
    end
    local config_thread = coroutine.create(config_func)
    local config_success

    local sw = stopwatch()
    sw:start()

    config_success, config_err_msg = coroutine.resume(config_thread)
    if not config_success then
        print("error in config file: " .. config_err_msg .. "\n" .. debug.traceback(config_thread))
        os.exit(-1)
    end

    sw:stop()
    print("lua-cmake: configured (" .. sw:get_pretty_seconds() .. "s)")
end

if not cmake.get_version() then
    error("A cmake version is required to be set! cmake.version(...)")
end

if args.optimize then
    local sw = stopwatch()
    sw:start()

    ---@diagnostic disable-next-line: invisible
    cmake.generator.optimize()

    sw:stop()
    print("lua-cmake: optimized (" .. sw:get_pretty_seconds() .. "s)")
else
    print("lua-cmake: optimizer disabled")
end

do
    local sw = stopwatch()
    sw:start()

    local cmake_file = io.open(args.output, "w+")
    if not cmake_file then
        error("unable to open output file: " .. args.output)
    end

    ---@param ... string
    local function write(...)
        cmake_file:write(...)
    end

    local writer = string_writer(write)

    ---@diagnostic disable-next-line: invisible
    cmake.generator.generate(writer)

    cmake_file:close()

    sw:stop()
    print("lua-cmake: generated (" .. sw:get_pretty_seconds() .. "s)")
end

sw_total:stop()
print("lua-cmake: total (" .. sw_total:get_pretty_seconds() .. "s)")
