cmake.version("3.28")

cmake.targets.collection.srcs({
    name = "test_srcs_collection",
    srcs = {
        "test_srcs.cpp",
    }
})

cmake.targets.cxx.library({
    name = "test_lib",
    type = "static",
    exclude_from_all = true,
    srcs = {
        "test2.cpp"
    },
    deps = {
        "test_srcs_collection"
    }
})

cmake.add_subdirectory("test")

cmake.include_directories("test", "test2")

cmake.include("test")

cmake.add_definition("test", "etset")
cmake.add_definition("testasd", "etsetasd")

cmake._if("${CMAKE_BUILD_TYPE} STREQUAL \"Debug\"", function()
end)._else(function ()
    cmake.set("set", "sete")
end)
