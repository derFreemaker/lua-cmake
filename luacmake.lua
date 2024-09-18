-- test file
local exe = require("targets.cxx.executable")

cmake.cmake_minimum_required("3.28")

exe {
    name = "test",
    srcs = {
        "test.cpp"
    },
    hdrs = {
        "test.h"
    }
}
