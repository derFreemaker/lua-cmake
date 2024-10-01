-- test file
-- local exe = require("lua-cmake.target.cxx.executable")
-- local lib = require("lua-cmake.target.cxx.library")

-- local imported_exe = require("lua-cmake.target.imported.executable")
-- local imported_lib = require("lua-cmake.target.imported.library")

cmake.version("3.28")

cmake.targets.imported.executable({
    name = "test_exe_imported",
    global = true
})

cmake.targets.imported.library({
    name = "test_lib_imported",
    type = "static",
    global = true
})

cmake.targets.cxx.executable({
    name = "test_exe",
    srcs = {
        "test.cpp"
    },
    hdrs = {
        "test.h"
    },
    options = {
        compile_definitions = {
            {
                type = "private",
                items = {
                    {
                        "Name",
                        "Test"
                    }
                }
            }
        },
        compile_features = {
            {
                type = "private",
                "compile_feature",
            }
        },
        compile_options = {
            before = true,
            {
                type = "public",
                "test",
            }
        }
    }
})

cmake.targets.cxx.library({
    name = "test_lib",
    type = "static",
    exclude_from_all = true,
    srcs = {
        "test.cpp",
        "test2.cpp"
    },
})

cmake.include_directories("test", "test2")

cmake.include("test")

cmake.add_definition("test", "etset")
cmake.add_definition("testasd", "etsetasd")

cmake._if("${CMAKE_BUILD_TYPE} STREQUAL \"Debug\"", function()
    cmake.set("Test", "Test")
end)

cmake.add_subdirectory("test")
