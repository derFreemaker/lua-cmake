-- Function to detect the operating system
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
parser:argument("entry", "The entry file for lua-cmake.", "cmake.lua")
parser:option("-o --output", "The output file path in which the generate cmake gets written to.", "CMakeLists.txt")

---@type { entry: string }
local args = parser:parse()

--//TODO: add version flag

local full_entry_path = lfs.currentdir() .. "/" .. args.entry
if lfs.attributes(full_entry_path) == nil then
    error("Entry file not found: " .. full_entry_path)
end
print("lua-cmake: entry file: " .. full_entry_path)

local registry = require("lua-cmake.cmake.registry")
CMake = require("lua-cmake.cmake.cmake")

do
    local time_start = os.clock()

    -- load and run entry lau file
    local entry_path = lfs.currentdir() .. "/" .. args.entry
    local entry_func, entry_err_msg = loadfile(entry_path, "t")
    if not entry_func then
        error("unable to load entry file: '" .. entry_path .. "' \nerror:\n  " .. entry_err_msg)
    end
    local entry_success
    entry_success, entry_err_msg = pcall(entry_func)
    if not entry_success then
        error("lua-cmake: entry file: error while executing: " .. entry_err_msg)
    end

    local time_end = os.clock()
    ---@type integer | string
    local time_diff = math.floor((time_end - time_start) * 10) / 10
    if time_diff < 0.1 then
        time_diff = "<0.1"
    end

    print("lua-cmake: configured (" .. time_diff .. "s)")
end

-- checking
if not registry:check() then
    return
end
if not CMake:cmake_version() then
    error("A cmake version is required to be set! CMake:cmake_version({version})")
end

--//TODO: move this some where else

do
    local time_start = os.clock()

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
    cmake_file:write("cmake_minimum_required(VERSION " .. CMake:cmake_version() .. ")\n")
    cmake_file:write(require("lua-cmake.utils.string").join(target_cmake_lines, "\n"))
    cmake_file:close()

    local time_end = os.clock()

    ---@type integer | string
    local time_diff = math.floor((time_end - time_start) * 10) / 10
    if time_diff < 0.1 then
        time_diff = "<0.1"
    end

    print("lua-cmake: generated (" .. time_diff .. "s)")
end
