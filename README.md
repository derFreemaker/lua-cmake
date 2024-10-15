# NOT FINISHED

# lua-cmake
Configure CMake in lua.

## Get Started
1. Clone the repo
2. Set `LUA_CMAKE_DIR` env variable to `{your_repo_path}`
- The env variable is need since lua has no good builtin way to get the current location there for using a env variable was my choice.

## Usage
Add a `luacmake.lua` in your repo root and everything can be configured over the `cmake` global.

For command options use `lua-cmake -h`.

## TODO
- feature complete
- tests

## Goal
The goal is to make writing complex system in cmake easier by making you able to configure in lua.
The way it works is it generates a cmake file based on the configuration, this makes you able to use all the cmake features.

## Builtin
- For filesystem interactions [lua-filesystem](https://lunarmodules.github.io/luafilesystem) is comming with it and can be required with `require("lfs")`.
- In order to over engineer this a [class system](https://github.com/derFreemaker/lua-class-system) is builtin with the two gobal functions `class`, `interface`. (can be required with `require("lua-cmake.third_party.derFreemaker.class_system")`)

## Third-Party
- [argparse](https://github.com/mpeterv/argparse)
- [lua-filesystem](https://lunarmodules.github.io/luafilesystem)

## My Libraries
- [my-utils](https://github.com/derFreemaker/Freemaker.Lua)
- [lua-class-system](https://github.com/derFreemaker/Lua-Class-System)
- [lua-valid](https://github.com/derFreemaker/lua-valid)
