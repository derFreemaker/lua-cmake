-- test file
local exe = require("lua-cmake.targets.cxx.executable")

cmake.cmake_minimum_required("3.28...3.30.3")
cmake.cmake_minimum_required("3.27...3.29.3")

exe {
    name = "test",
    srcs = {
        "test.cpp"
    },
    hdrs = {
        "test.h"
    }
}

cmake.set("Test", false)
