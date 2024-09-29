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
    local os_name = get_os()

    local lua_cmake_dir = os.getenv("LUA_CMAKE_DIR")
    if lua_cmake_dir == nil then
        error("LUA_CMAKE_DIR env variable not defined. Is needed for loading libraries.")
    end

    if os_name == "windows" then
        lua_cmake_dir = lua_cmake_dir:gsub("/", "\\")
        if lua_cmake_dir:sub(lua_cmake_dir:len() - 1) ~= "\\" then
            lua_cmake_dir = lua_cmake_dir .. "\\"
        end

        -- For Windows: add the path to the directory containing the .dll
        package.cpath = package.cpath .. ";" .. lua_cmake_dir .. "lib\\?.dll"
        package.path = package.path .. ";" .. lua_cmake_dir .. "\\lua\\?.lua"
    else
        if lua_cmake_dir:sub(lua_cmake_dir:len() - 1) ~= "/" then
            lua_cmake_dir = lua_cmake_dir .. "/"
        end

        -- For Linux: add the path to the directory containing the .so
        package.cpath = package.cpath .. ";" .. lua_cmake_dir .. "lib/?.so"
        package.path = package.path .. ";" .. lua_cmake_dir .. "/lua/?.lua"
    end
end
setup_path()

---@type boolean, lfs
local lfs_status, lfs = pcall(require, "lfs")
if not lfs_status then
    error("Failed to load LuaFileSystem library: " .. lfs)
end
require("lua-cmake.third_party.derFreemaker.class_system")

local cli_parser = require("lua-cmake.third_party.other.cli_parser")
local parser = cli_parser("lua-cmake", "Used to generate cmake files configured from lua.")
parser:argument("config", "The config file for lua-cmake.", "luacmake.lua")
parser:option("-o --output", "The output file path in which the generate cmake gets written to.", "CMakeLists.txt")
parser:flag("-p --no-optimize", "Sets the optimizer should NOT be run. (Disabling can improve stability)")

---@type { config: string, output: string | nil, no_optimize: boolean }
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

require("lua-cmake.cmake.cmake")

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

if not args.no_optimize then
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

    local writer = require("lua-cmake.utils.string_writer")(write)

    ---@diagnostic disable-next-line: invisible
    cmake.generator.generate(writer)

    cmake_file:close()

    sw:stop()
    print("lua-cmake: generated (" .. sw:get_pretty_seconds() .. "s)")
end

sw_total:stop()
print("lua-cmake: total (" .. sw_total:get_pretty_seconds() .. "s)")
