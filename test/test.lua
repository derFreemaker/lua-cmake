-- test file
local exe = require("lua-cmake.targets.cxx.executable")
local lib = require("lua-cmake.targets.cxx.library")

cmake.version("3.28")

exe {
    name = "test",
    srcs = {
        "test.cpp"
    },
    hdrs = {
        "test.h"
    }
}

lib {
    name = "test2",
    type = "static",
    exclude_from_all = true,
    srcs = {
        "test.cpp",
        "test2.cpp"
    },
}
