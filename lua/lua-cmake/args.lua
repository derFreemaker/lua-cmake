---@type lfs
local lfs = require("lfs")
---@type argparse
local argparse = require("lua-cmake.third_party.mpeterv.argparse")

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
    if path == "." then
        return relative
    end

    local new_path

    if get_os() == "windows" then
        local str = path:sub(2, 2)
        if str == ":" then
            new_path = path
        else
            if path:sub(1, 1) ~= "/" then
                path = "/" .. path
            end
            new_path = relative .. path
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

local parser = argparse("lua-cmake", "Used to generate cmake files configured from lua.")

do
    local current_dir = lfs.currentdir()
    if not current_dir then
        cmake.fatal_error("unable to get current working directory")
    end
    ---@cast current_dir -nil

    parser:argument("project_dir")
        :description("The project dir location.")
        :default(".")
        :convert(function(value)
            local project_dir = make_path_absolute(value, current_dir):gsub("\\", "/")
            return project_dir
        end)

    parser:option("-c --config")
        :description("The config file path.")
        :default(".config/luacmake.lua")
        :convert(function(value)
            return make_path_absolute(value, current_dir)
        end)

    parser:option("-i --input")
        :description("The config file for lua-cmake should run.")

    parser:option("-o --output")
        :description("The output file path in which the generate cmake gets written to.")

    parser:flag("-p --optimize")
        :description("Enables the optimizer.")

    parser:flag("-q --no-optimize")
        :description("Disables the optimizer. (disabling might fix issues)")
        :action(function(args)
            args.optimize = false
        end)

    parser:flag("-d --verbose")

    parser:flag("-f --force")

    print("lua-cmake version 0.1")
    parser:flag("-v --version")
        :action(function()
            os.exit(0)
        end)
end

---@alias lua-cmake.arguments.raw { project_dir: string, config: string, input: string | nil, output: string | nil, optimize: boolean | nil, verbose: boolean | nil, force: boolean | nil }
---@alias lua-cmake.arguments { project_dir: string, config: string, input: string, output: string, optimize: boolean, verbose: boolean, force: boolean }

---@class lua-cmake.arguments.lib
local arguments = {}

---@param args string[]
---@return lua-cmake.arguments.raw
function arguments.get_args(args)
    return parser:parse(args)
end

---@param args lua-cmake.arguments.raw
---@param config lua-cmake.config
---@return lua-cmake.arguments
function arguments.resolve_args(args, config)
    cmake.project_dir = args.project_dir

    local current_dir = lfs.currentdir()
    if not current_dir then
        cmake.fatal_error("unable to get current working directory")
    end
    ---@cast current_dir -nil

    if not args.input then
        args.input = config.config
    end
    args.input = make_path_absolute(args.input, current_dir)

    if not args.output then
        args.output = config.cmake
    end
    args.output = make_path_absolute(args.output, current_dir)

    if not args.optimize then
        args.optimize = config.optimize
    end
    if not args.verbose then
        args.verbose = config.verbose
    end
    if not args.force then
        args.force = false
    end

    ---@cast args lua-cmake.arguments
    return args
end

return arguments
