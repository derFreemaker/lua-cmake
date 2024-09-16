-- test file

CMake:cmake_version("3.28")

local exe = require("lua-cmake.targets.cxx.executable")

exe({
    name = "test",
    srcs = {
        "test.cpp"
    },
    hdrs = {
        "test.h"
    }
})
