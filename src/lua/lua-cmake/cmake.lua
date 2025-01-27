---@class lua-cmake
---@field config { lua_cmake: lua-cmake.config } | table
---@field args lua-cmake.arguments
---@field verbose boolean
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
            ---@type lua-cmake.target.collection.files
            files = require("lua-cmake.target.collection.files"),
            ---@type lua-cmake.target.collection.objects
            objects = require("lua-cmake.target.collection.objects"),
        },
        common = {
            ---@type lua-cmake.target.common.interface
            interface = require("lua-cmake.target.common.interface"),
            ---@type lua-cmake.target.common.library
            library = require("lua-cmake.target.common.library"),
            ---@type lua-cmake.target.common.executable
            executable = require("lua-cmake.target.common.executable"),
        },
        imported = {
            ---@type lua-cmake.target.imported.package
            package = require("lua-cmake.target.imported.package"),
        },
    },
}

---@param msg string
function cmake.log_verbose(msg)
    if not cmake.verbose then
        return
    end
    print("lua-cmake: " .. msg)
end

---@param msg string
function cmake.log(msg)
    print("lua-cmake: " .. msg)
end

---@param msg string
function cmake.error(msg)
    print("lua-cmake error: " .. msg)
end

---@param msg string
function cmake.fatal_error(msg)
    print("lua-cmake: " .. msg)
    os.exit(-1)
end

---@param args string[]
---@return lua-cmake
return function(args)
    local arguments = require("lua-cmake.args")
    args = arguments.get_args(args)
    cmake.config = require("lua-cmake.config")(args.config)
    cmake.args = arguments.resolve_args(args, cmake.config.lua_cmake)
    cmake.verbose = cmake.args.verbose

    cmake.path_resolver = require("lua-cmake.filesystem.path_resolver")
    cmake.registry = require("lua-cmake.dep.registry")
    cmake.generator = require("lua-cmake.gen.generator")

    local commands = {
        "add_definitions",
        "add_subdirectory",
        "compile_options",
        "enable_testing",
        "if",
        "include_directories",
        "include",
        "project",
        "set",
        "version",
        "write",
    }
    for _, command in ipairs(commands) do
        require("lua-cmake.commands." .. command)
    end

    return cmake
end
