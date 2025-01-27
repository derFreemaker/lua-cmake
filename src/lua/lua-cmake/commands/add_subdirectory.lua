---@type lfs
local lfs = require("lfs")

---@class lua-cmake
local cmake = _G.cmake

---@param source_dir string
---@param file_name string | nil
function cmake.add_subdirectory(source_dir, file_name)
    local current_dir = lfs.currentdir()
    if not current_dir then
        cmake.fatal_error("unable to get current directory")
    end
    ---@cast current_dir -nil

    source_dir = cmake.path_resolver.resolve_path(source_dir, true)
    file_name = file_name or cmake.config.lua_cmake.config

    local file_path = source_dir .. "/" .. file_name
    local func, error_msg = loadfile(file_path)
    if not func then
        cmake.fatal_error("unable to load file: " .. file_path .. "\n" .. error_msg)
    end
    ---@cast func -nil

    lfs.chdir(source_dir)

    local thread = coroutine.create(func)
    local success, thread_error_msg = coroutine.resume(thread)
    if not success then
        cmake.fatal_error("error when executing file: " .. file_path .. "\n" .. debug.traceback(thread, thread_error_msg))
    end

    lfs.chdir(current_dir)
end
