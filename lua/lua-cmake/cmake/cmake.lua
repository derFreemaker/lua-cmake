---@class lua-cmake.cmake
---@field generator lua-cmake.gen.generator
---@field targets lua-cmake.targets
---
---@field private m_min_cmake_version integer[] | nil
---@field private m_max_cmake_version integer[] | nil
local cmake = {
    generator = require("lua-cmake.gen.generator"),
    ---@diagnostic disable: missing-fields
    targets = {
        cxx = {},
        imported = {}
    }
    ---@diagnostic enable: missing-fields
}
_G.cmake = cmake

-- commands
require("lua-cmake.cmake.commands.add_definitions")
require("lua-cmake.cmake.commands.add_subdirectory")
require("lua-cmake.cmake.commands.compile_options")
require("lua-cmake.cmake.commands.if")
require("lua-cmake.cmake.commands.include_directories")
require("lua-cmake.cmake.commands.include")
require("lua-cmake.cmake.commands.set")
require("lua-cmake.cmake.commands.version")
require("lua-cmake.cmake.commands.write")

-- targets
cmake.targets.cxx.executable = require("lua-cmake.target.cxx.executable")
cmake.targets.cxx.library = require("lua-cmake.target.cxx.library")

cmake.targets.imported.executable = require("lua-cmake.target.imported.executable")
cmake.targets.imported.library = require("lua-cmake.target.imported.library")
cmake.targets.imported.package = require("lua-cmake.target.imported.package")
