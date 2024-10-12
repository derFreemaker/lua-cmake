local utils = require("lua-cmake.utils")
local string_builder = require("lua-cmake.utils.string_builder")

local min_cmake_version
local max_cmake_version

---@class lua-cmake
local cmake = _G.cmake

---@return string | nil
function cmake.get_version()
    if not min_cmake_version then
        return nil
    end
    local builder = string_builder()

    builder:append(table.concat(min_cmake_version, "."))

    if max_cmake_version then
        builder:append("...", table.concat(max_cmake_version, "."))
    end

    return builder:build()
end

---@param version string
function cmake.version(version)
    local splited_version = utils.string.split(version, "...")
    local min_version = utils.table.map(utils.string.split(splited_version[1], "."),
        function(value)
            return tonumber(value)
        end)
    local max_version = utils.table.map(utils.string.split(splited_version[2], "."),
        function(value)
            return tonumber(value)
        end)

    if #min_version > 0 then
        local min_replace = false
        if not min_cmake_version then
            min_replace = true
        else
            for index, value in ipairs(min_version) do
                local old_value = min_cmake_version[index]
                if not old_value or old_value < value then
                    min_replace = true
                    break
                end
            end
        end
        if min_replace then
            min_cmake_version = min_version
        end
    end

    if #max_version > 0 then
        local max_replace = false
        if not max_cmake_version then
            max_replace = true
        else
            for index, value in ipairs(max_version) do
                local old_value = max_cmake_version[index]
                if not old_value or old_value > value then
                    max_replace = true
                    break
                end
            end
        end
        if max_replace then
            max_cmake_version = max_version
        end
    end

    if min_cmake_version and max_cmake_version then
        local min_bigger_than_max = false

        for index, min_value in ipairs(min_cmake_version) do
            local max_value = max_cmake_version[index]
            if not max_value or max_value < min_value then
                min_bigger_than_max = true
                break
            end
        end

        if min_bigger_than_max then
            error("Minimum cmake version can not be bigger than maximum cmake version."
                .. " Check your cmake version configurations!")
        end
    end
end

cmake.generator.add_action({
    kind = "cmake-version",
    ---@param context { get_version: fun() : string }
    func = function(builder, context)
        builder:write_line("cmake_minimum_required(VERSION ", context.get_version(), " FATAL_ERROR)")
    end,
    context = {
        get_version = cmake.get_version,
    },
})
