local config = require("lua-cmake.config")
cmake = { config = config }

---@class lua-cmake
---@field config { lua_cmake: lua-cmake.config } | table
---@field args lua-cmake.args
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

-- its important that the config gets loaded before args are parsed
cmake.config = require("lua-cmake.config")
cmake.args = require("lua-cmake.args")({ ... }, config.lua_cmake)

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