-- test file
local exe = require("lua-cmake.target.cxx.executable")
local lib = require("lua-cmake.target.cxx.library")

local imported_exe = require("lua-cmake.target.imported.executable")
local imported_lib = require("lua-cmake.target.imported.library")

cmake.version("3.28")

imported_exe {
    name = "test_exe_imported",
    global = true
}

imported_lib {
    name = "test_lib_imported",
    type = "unknown",
    global = true
}

exe {
    name = "test_exe",
    srcs = {
        "test.cpp"
    },
    hdrs = {
        "test.h"
    }
}

lib {
    name = "test_lib",
    type = "static",
    exclude_from_all = true,
    srcs = {
        "test.cpp",
        "test2.cpp"
    },
}

cmake.include_directories("test", "test2")

cmake.include("test")

cmake.set("test", "asd")
cmake.set("test2", "asdasd")
cmake.set("test2", "asdasdasd")
cmake.set("test", "asdasdasasd")
cmake.set("test", "asd")

cmake.include("test")
cmake.include("test23")
cmake.include("test23")

cmake.include_directories("test2", "test")