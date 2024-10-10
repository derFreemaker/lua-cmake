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
local string_writer = require("lua-cmake.utils.string_writer")

--//? We are loading cmake like this to pass the var args to it.
loadfile(lua_cmake_dir .. "lua/lua-cmake/cmake/cmake.lua")(...)

if not lfs.exists(cmake.args.input) then
    error("config file not found: " .. cmake.args.input)
end
if cmake.config.lua_cmake.verbose then
    print("lua-cmake: config file '" .. cmake.args.input .. "'")
end

local stopwatch = require("lua-cmake.utils.stopwatch")
local sw_total = stopwatch()
sw_total:start()

do
    local config_func, config_err_msg = loadfile(cmake.args.input, "t")
    if not config_func then
        error("unable to load entry file: '" .. cmake.args.input .. "' \nerror:\n  " .. config_err_msg)
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

    ---@diagnostic disable-next-line: invisible
    local has_error = cmake.registry.resolve()
    if has_error then
        print("lua-cmake: dependencies resolved with error(s) (this probably will corrupt the configuration)")
    end

    sw:stop()
    print("lua-cmake: configured (" .. sw:get_pretty_seconds() .. "s)")
end

if not cmake.get_version() then
    error("A cmake version is required to be set! cmake.version(...)")
end

if cmake.args.optimize then
    local sw = stopwatch()
    sw:start()

    ---@diagnostic disable-next-line: invisible
    local has_error = cmake.generator.optimize()
    if has_error then
        print("lua-cmake: optimizer finished with error(s) (this probably will corrupt the configuration)")
    end

    sw:stop()
    print("lua-cmake: optimized (" .. sw:get_pretty_seconds() .. "s)")
else
    print("lua-cmake: optimizer disabled")
end

do
    local sw = stopwatch()
    sw:start()

    local cmake_file = io.open(cmake.args.output, "w+")
    if not cmake_file then
        error("unable to open output file: " .. cmake.args.output)
    end

    ---@param ... string
    local function write(...)
        cmake_file:write(...)
    end

    local writer = string_writer(write)

    ---@diagnostic disable-next-line: invisible
    local has_error = cmake.generator.generate(writer)
    if has_error then
        print("lua-cmake: generator finished with error(s)")
        cmake_file:write("\nmessage(FATAL_ERROR \"lua-cmake generator failed with error(s)\")")
    end

    cmake_file:close()

    sw:stop()
    print("lua-cmake: generated (" .. sw:get_pretty_seconds() .. "s)")
end

sw_total:stop()
print("lua-cmake: total " .. sw_total:get_pretty_seconds() .. "s")
