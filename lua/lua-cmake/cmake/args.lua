local lfs = require("lfs")
local cli_parser = require("lua-cmake.third_party.mpeterv.cli_parser")

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

local parser = cli_parser("lua-cmake", "Used to generate cmake files configured from lua.")
parser:option("-i --input")
    :description("The config file for lua-cmake should run.")
    :default(cmake.config.lua_cmake.default_config)

parser:option("-o --output")
    :description("The output file path in which the generate cmake gets written to.")
    :default(cmake.config.lua_cmake.default_cmake)

parser:flag("-p --optimize")
    :description("Enables the optimizer.")
    :default(cmake.config.lua_cmake.optimize)

parser:flag("-q --no-optimize")
    :description("Disables the optimizer. (disabling might fix issues)")
    :action(function(args)
        args.optimize = false
    end)

parser:flag("-v --verbose")
    :default(cmake.config.lua_cmake.verbose)

--//TODO: add version flag

---@alias lua-cmake.cmake.args { input: string, output: string | nil, optimize: boolean }
---@return lua-cmake.cmake.args
return function(args)
    args = parser:parse(args)

    local current_dir = lfs.currentdir()
    if not current_dir then
        error("unable to get current directory")
    end

    args.input = make_path_absolute(args.input, current_dir)
    args.output = make_path_absolute(args.output, current_dir)

    local reverse = args.input:reverse()
    local pos = reverse:find("/", reverse:find("/", nil, true), true)
    local parent_folder = args.input:sub(0, reverse:len() - pos)
    lfs.chdir(parent_folder)

    return args
end
