-- test file
local cmake = require("cmake")
local exe = require("lua-cmake.targets.cxx.executable")

cmake:cmake_version("3.28")

exe {
    name = "test",
    srcs = {
        "test.cpp"
    },
    hdrs = {
        "test.h"
    }
}
