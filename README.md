# lua-cmake
Lua wrapper for cmake.

## Goal
The goal is to make writing complex system in cmake easier by make you able to configure in lua.

## Function
Generates a cmake file based on the configuration. This makes you able to use all the cmake features but configure in lua which makes lists or arrays way easier and simpler.
For filesystem interations [LuaFileSystem](https://lunarmodules.github.io/luafilesystem/) is comming with it and can be required directly like so `require("lfs")`.
In order to over engineer this also a [ClassSystem](https://github.com/derFreemaker/Lua-Class-System) is builtin with the two functions `class`, `interface` and can be require like so `require("lua-cmake.third_party.derFreemaker.ClassSystem")`.
