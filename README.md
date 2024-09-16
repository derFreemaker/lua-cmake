# lua-cmake
CMake generator in lua.

## Get Started
1. Clone the repo
2. Add `{your_repo_path}/bin` to `PATH` env variable
3. Set `LUA_CMAKE_DIR` to `{your_repo_path}`

## Goal
The goal is to make writing complex system in cmake easier by making you able to configure in lua.
The way it works is it generates a cmake file based on the configuration, this makes you able to use all the cmake features.

## Builtin Systems
- For filesystem interactions [LuaFileSystem](https://lunarmodules.github.io/luafilesystem) is comming with it and can be required directly like so `require("lfs")`.
- In order to over engineer this also a [ClassSystem](https://github.com/derFreemaker/Lua-Class-System) is builtin with the two gobal functions `class`, `interface` and can be require like so `require("lua-cmake.third_party.derFreemaker.ClassSystem")`.
