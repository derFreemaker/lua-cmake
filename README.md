# NOT FINISHED & NOT RECOMMENDED
Its a personal project there for its not good code or optimized.

# lua-cmake
Configure CMake in lua.

## Goal
The goal is to make writing complex system in cmake easier by making you able to configure in lua.
The way it works is it generates a cmake file based on the configuration, this makes you able to use all the cmake features.

## Required Dependecies
- [lua-filesystem](https://lunarmodules.github.io/luafilesystem)

## Get Started
1. clone repo
2. Use lua-cmake files in bin directory

## Usage
Add `luacmake.lua`(default) in your repo root and everything can be configured over the `cmake` global.

For command options use `lua-cmake -h`.

## Config
`.config/luacmake.lua` is where `lua-cmake` will look for a config.
As prescribed in [config-dir](https://github.com/pi0/config-dir).

`lua_cmake`
- `config: string`: Default entry file for `lua-cmake`.
- `cmake: string`: Default output file for `lua-cmake`.
- `optimize: boolean`: Default if optimizer should be enabled.
- `verbose: boolean`: Default if `lua-cmake` should give a verbose output.
- `plugins: string[]`: Plugins that need to be loaded before configuration starts. If one fails or is missing `lua-cmake` will stop the process and report back. A plugin can be a `single file` or a `directory`, if a directory is given it will search for `init.lua` as entry point.

## Builtin
- In order to over engineer this a [class system](https://github.com/derFreemaker/lua-class-system) is builtin with the two gobal functions `class`, `interface`. (can be required with `require("lua-cmake.third_party.derFreemaker.class_system")`)
- Metadata for all apis are included.

## Third-Party
- [argparse](https://github.com/mpeterv/argparse)
- [lua-filesystem](https://lunarmodules.github.io/luafilesystem)

## My Libraries
- [my-utils](https://github.com/derFreemaker/Freemaker.Lua)
- [lua-class-system](https://github.com/derFreemaker/Lua-Class-System)
- [lua-valid](https://github.com/derFreemaker/lua-valid)
