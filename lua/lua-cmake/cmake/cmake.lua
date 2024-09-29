---@class lua-cmake.cmake
---@field generator lua-cmake.gen.generator
---
---@field private m_min_cmake_version integer[] | nil
---@field private m_max_cmake_version integer[] | nil
local cmake = {
    generator = require("lua-cmake.gen.generator"),
}
_G.cmake = cmake

require("lua-cmake.cmake.commands.write")
require("lua-cmake.cmake.commands.version")
require("lua-cmake.cmake.commands.set")
require("lua-cmake.cmake.commands.include")
require("lua-cmake.cmake.commands.include_directories")
require("lua-cmake.cmake.commands.compile_options")
require("lua-cmake.cmake.commands.add_definitions")
require("lua-cmake.cmake.commands.if")
