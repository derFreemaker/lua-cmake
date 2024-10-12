local lfs = require("lfs")
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

---@alias lua-cmake.cmake.args { input: string, output: string | nil, optimize: boolean, verbose: boolean }
---@param args table
---@param config lua-cmake.config
---@return lua-cmake.cmake.args
return function(args, config)
    local parser = argparse("lua-cmake", "Used to generate cmake files configured from lua.")
    parser:option("-i --input")
        :description("The config file for lua-cmake should run.")
        :default(config.config)

    parser:option("-o --output")
        :description("The output file path in which the generate cmake gets written to.")
        :default(config.cmake)

    parser:flag("-p --optimize")
        :description("Enables the optimizer.")
        :default(config.optimize)

    parser:flag("-q --no-optimize")
        :description("Disables the optimizer. (disabling might fix issues)")
        :action(function(x)
            x.optimize = false
        end)

    parser:flag("-v --verbose")
        :default(config.verbose)

    --//TODO: add version flag

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
    cmake.project_dir = parent_folder

    return args
end
