local cli_parser = require("lua.lua-cmake.third_party.mpeterv.cli_parser")

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

---@return { config: string, output: string | nil, optimize: boolean }
return function(args)
    return parser:parse(args)
end
