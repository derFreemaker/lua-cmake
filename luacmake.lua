-- test file
local exe = require("lua-cmake.targets.cxx.executable")

cmake.version("3.28...3.30.3")
cmake.version("3.27...3.29.3")

exe {
    name = "test",
    srcs = {
        "test.cpp"
    },
    hdrs = {
        "test.h"
    }
}
