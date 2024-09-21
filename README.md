# lua-cmake
CMake generator in lua.

## Get Started
1. Clone the repo
2. Set `LUA_CMAKE_DIR` env variable to `{your_repo_path}`
- The env variable is need since lua has no good builtin way to get the current location there for using a env variable was my choice.

## Usage
Add a `luacmake.lua` in your repo root and everything can be configured over the `cmake` global.

For command options use `lua-cmake -h`.

## Goal
The goal is to make writing complex system in cmake easier by making you able to configure in lua.
The way it works is it generates a cmake file based on the configuration, this makes you able to use all the cmake features.

## Builtin Systems
- For filesystem interactions [LuaFileSystem](https://lunarmodules.github.io/luafilesystem) (with some small additions) is comming with it and can be required directly like so `require("lfs")`.
- In order to over engineer this a [ClassSystem](https://github.com/derFreemaker/Lua-Class-System) is builtin with the two gobal functions `class`, `interface` and can be require like so `require("lua-cmake.third_party.derFreemaker.ClassSystem")`.
