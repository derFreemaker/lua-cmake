local utils_string = require("lua-cmake.utils.string")
local utils_table = require("lua-cmake.utils.table")


local generator = require("lua-cmake.gen.generator")

---@class lua-cmake.cmake
---@field m_min_cmake_version integer[] | nil
---@field m_max_cmake_version integer[] | nil
cmake = {}

---@return string | nil
function cmake.get_cmake_minimum_required()
    if not cmake.m_min_cmake_version then
        return nil
    end

    local min_cmake_version_str = utils_table.map(cmake.m_min_cmake_version, function(value)
        return tostring(value)
    end)
    local str = utils_string.join(min_cmake_version_str, ".")

    if cmake.m_max_cmake_version then
        local max_cmake_version_str = utils_table.map(cmake.m_max_cmake_version, function(value)
            return tostring(value)
        end)
        str = str .. "..." .. utils_string.join(max_cmake_version_str, ".")
    end

    return str
end

---@param version string
function cmake.cmake_minimum_required(version)
    local splited_version = utils_string.split(version, "...")
    local min_version = utils_table.map(utils_string.split(splited_version[1], "."),
        function(value)
            return tonumber(value)
        end)
    local max_version = utils_table.map(utils_string.split(splited_version[2], "."),
        function(value)
            return tonumber(value)
        end)

    if #min_version > 0 then
        local min_replace = false
        if not cmake.m_min_cmake_version then
            min_replace = true
        else
            for index, value in ipairs(min_version) do
                local old_value = cmake.m_min_cmake_version[index]
                if not old_value or old_value < value then
                    min_replace = true
                    break
                end
            end
        end
        if min_replace then
            cmake.m_min_cmake_version = min_version
        end
    end

    if #max_version > 0 then
        local max_replace = false
        if not cmake.m_max_cmake_version then
            max_replace = true
        else
            for index, value in ipairs(max_version) do
                local old_value = cmake.m_max_cmake_version[index]
                if not old_value or old_value > value then
                    max_replace = true
                    break
                end
            end
        end
        if max_replace then
            cmake.m_max_cmake_version = max_version
        end
    end

    if cmake.m_min_cmake_version and cmake.m_max_cmake_version then
        local min_bigger_than_max = false

        for index, min_value in ipairs(cmake.m_min_cmake_version) do
            local max_value = cmake.m_max_cmake_version[index]
            if not max_value or max_value < min_value then
                min_bigger_than_max = true
                break
            end
        end

        if min_bigger_than_max then
            error(
                "Minimum cmake version can not be bigger than maximum cmake version. Check your cmake version configurations!")
        end
    end
end

generator:add_action({
    name = "cmake-version",
    version = cmake.get_cmake_minimum_required(),
    func = function(self)
        return "cmake_minimum_required(VERSION " .. self.version .. " FATAL_ERROR)"
    end
})

---@param variable string
---@param value string | boolean
function cmake.set(variable, value)
    if value == true then
        value = "TRUE"
    elseif value == false then
        value = "FALSE"
    end

    generator:add_action({
        name = "set",
        variable = variable,
        value = value,
        func = function(self)
            return "set(" .. self.variable .. " " .. self.value .. ")"
        end,
    })
end
