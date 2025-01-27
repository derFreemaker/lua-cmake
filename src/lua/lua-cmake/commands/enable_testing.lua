---@class lua-cmake
local cmake = _G.cmake

function cmake.enable_testing()
    cmake.write_line("enable_testing()")
end
