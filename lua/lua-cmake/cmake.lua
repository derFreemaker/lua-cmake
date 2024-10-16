---@class lua-cmake
---@field config { lua_cmake: lua-cmake.config } | table
---@field args lua-cmake.arguments
---
---@field path_resolver lua-cmake.filesystem.path_resolver
---
---@field registry lua-cmake.dep.registry
---@field generator lua-cmake.gen.generator
---
---@field project_dir string
cmake = {
    targets = {
        collection = {
            objects = require("lua-cmake.target.collection.objects"),
        },
        cxx = {
            executable = require("lua-cmake.target.cxx.executable"),
            library = require("lua-cmake.target.cxx.library"),
        },
        imported = {
            package = require("lua-cmake.target.imported.package"),
        },
    },
    project = require("lua-cmake.project"),
}

---@param msg string
function cmake.fatal_error(msg)
    print("lua-cmake: " .. msg)
    os.exit(-1)
end

local arguments = require("lua-cmake.args")
local args = arguments.get_args({...})
cmake.config = require("lua-cmake.config")(args.config)
cmake.args = arguments.resolve_args(args, cmake.config.lua_cmake)

cmake.path_resolver = require("lua-cmake.filesystem.path_resolver")
cmake.registry = require("lua-cmake.dep.registry")
cmake.generator = require("lua-cmake.gen.generator")

--------------
-- commands --
--------------
local function load_command(name)
    require("lua-cmake.commands." .. name)
end

load_command("add_definitions")
load_command("add_subdirectory")
load_command("compile_options")
load_command("if")
load_command("include_directories")
load_command("include")
load_command("set")
load_command("version")
load_command("write")
