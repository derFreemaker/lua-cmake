cmake.targets.cxx.executable({
    name = "test_exe",
    srcs = {
        "test.cpp",
        "test_hi.cpp"
    },
    deps = {
        "test_lib"
    }
})
