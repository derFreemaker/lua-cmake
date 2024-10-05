local lfs = require("lfs")
local cli_parser = require("lua.lua-cmake.third_party.mpeterv.cli_parser")

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
parser:argument("config")
    :description("The config file for lua-cmake.")
    :default(cmake.config.lua_cmake.default_config)

parser:option("-o --output")
    :description("The output file path in which the generate cmake gets written to.")
    :default(cmake.config.lua_cmake.default_cmake)

parser:flag("-p --optimize")
    :description("enables the optimizer")
    :default(cmake.config.lua_cmake.optimize)
    :action(function(args)
        args.optimize = true
    end)

parser:flag("-q --no-optimize")
    :description("disables the optimizer")
    :action(function(args)
        args.optimize = false
        args.no_optimize = nil
    end)

--//TODO: add version flag

---@return { config: string, output: string | nil, optimize: boolean }
return function(args)
    args = parser:parse(args)

    local current_dir = lfs.currentdir()
    if not current_dir then
        error("unable to get current directory")
    end

    args.config = make_path_absolute(args.config, current_dir)
    args.output = make_path_absolute(args.output, current_dir)

    local reverse = args.config:reverse()
    local pos = reverse:find("/", reverse:find("/", nil, true), true)
    local parent_folder = args.config:sub(0, reverse:len() - pos)
    lfs.chdir(parent_folder)

    return args
end
