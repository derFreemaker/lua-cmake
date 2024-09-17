-- Function to detect the operating system
---@return "windows" | "linux"
local function get_os()
    if package.config:sub(1, 1) == '\\' then
        return "windows"
    else
        return "linux"
    end
end

-- Function to set the correct library path based on OS
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
require("lua-cmake.third_party.derFreemaker.ClassSystem")

local cli_parser = require("lua-cmake.third_party.other.cli_parser")
local parser = cli_parser("lua-cmake", "Used to generate cmake files configured from lua.")
parser:argument("config", "The config file for lua-cmake.", "luacmake.lua")
parser:option("-o --output", "The output file path in which the generate cmake gets written to.", "CMakeLists.txt")

---@type { config: string }
local args = parser:parse()

--//TODO: add version flag

-- load and run entry lau file
local config_path
if get_os() == "windows" then
    config_path = lfs.currentdir() .. "\\" .. args.config
else
    config_path = lfs.currentdir() .. "/" .. args.config
end

if lfs.attributes(config_path) == nil then
    error("config file not found: " .. config_path)
end
print("lua-cmake: config file '" .. config_path .. "'")

local registry = require("lua-cmake.cmake.registry")
local cmake = require("cmake")

do
    local stopwatch = require("lua-cmake.utils.stopwatch")()
    stopwatch:start()

    local config_func, config_err_msg = loadfile(config_path, "t")
    if not config_func then
        error("unable to load entry file: '" .. config_path .. "' \nerror:\n  " .. config_err_msg)
    end
    local config_thread = coroutine.create(config_func)
    local config_success
    config_success, config_err_msg = coroutine.resume(config_thread)
    if not config_success then
        print("error in config file: " .. config_err_msg .. "\n" .. debug.traceback(config_thread))
        os.exit(-1)
    end

    stopwatch:stop()
    ---@type number | string
    local time = math.floor(stopwatch:get_time_milliseconds() / 10) / 10
    if time < 0.1 then
        time = "<0.1"
    end

    print("lua-cmake: configured (" .. time .. "s)")
end

-- checking
if not registry:check() then
    return
end
if not cmake:cmake_version() then
    error("A cmake version is required to be set! CMake:cmake_version({version})")
end

--//TODO: move this some where else

do
    local stopwatch = require("lua-cmake.utils.stopwatch")()
    stopwatch:start()

    -- generating
    local target_cmake_lines = {}
    for _, target in pairs(registry:get_targets_inorder()) do
        table.insert(target_cmake_lines, target:generate_cmake() .. "\n")
    end

    -- writing
    local cmake_file = io.open(lfs.currentdir() .. "/CMakeLists.txt", "w+")
    if not cmake_file then
        error("unable to open 'CMakeLists.txt' file: " .. lfs.currentdir() .. "/CMakeLists.txt")
    end
    cmake_file:write("cmake_minimum_required(VERSION " .. cmake:cmake_version() .. ")\n")
    cmake_file:write(require("lua-cmake.utils.string").join(target_cmake_lines, "\n"))
    cmake_file:close()

    stopwatch:stop()
    ---@type number | string
    local time = math.floor(stopwatch:get_time_milliseconds() / 10) / 10
    if time < 0.1 then
        time = "<0.1"
    end

    print("lua-cmake: generated (" .. time .. "s)")
end
