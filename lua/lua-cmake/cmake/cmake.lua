---@class lua-cmake.cmake
---@field config { lua_cmake: lua-cmake.config } | table
---@field args lua-cmake.cmake.args
---
---@field path_resolver lua-cmake.filesystem.path_resolver
---
---@field registry lua-cmake.dep.registry
---@field generator lua-cmake.gen.generator
cmake = {
    targets = {
        collection = {},
        cxx = {},
        imported = {},
    },
    project = require("lua-cmake.cmake.project"),
}
cmake.config = require("lua-cmake.cmake.config")
cmake.args = require("lua-cmake.cmake.args")({ ... })
cmake.path_resolver = require("lua-cmake.filesystem.path_resolver")
cmake.registry = require("lua-cmake.dep.registry")
cmake.generator = require("lua-cmake.gen.generator")

--------------
-- commands --
--------------

require("lua-cmake.cmake.commands.add_definitions")
require("lua-cmake.cmake.commands.add_subdirectory")
require("lua-cmake.cmake.commands.compile_options")
require("lua-cmake.cmake.commands.if")
require("lua-cmake.cmake.commands.include_directories")
require("lua-cmake.cmake.commands.include")
require("lua-cmake.cmake.commands.set")
require("lua-cmake.cmake.commands.version")
require("lua-cmake.cmake.commands.write")

-------------
-- targets --
-------------

cmake.targets.collection.objects = require("lua-cmake.target.collection.objects")

cmake.targets.cxx.executable = require("lua-cmake.target.cxx.executable")
cmake.targets.cxx.library = require("lua-cmake.target.cxx.library")

cmake.targets.imported.package = require("lua-cmake.target.imported.package")
