local utils = require("lua-cmake.third_party.derFreemaker.utils.bin.utils")
local string_builder = require("lua-cmake.utils.string_builder")

---@class lua-cmake.cmake
---@field generator lua-cmake.gen.generator
---
---@field private m_min_cmake_version integer[] | nil
---@field private m_max_cmake_version integer[] | nil
local cmake = {
    generator = require("lua-cmake.gen.generator"),
}
_G.cmake = cmake

---@return string | nil
function cmake.get_version()
    if not cmake.m_min_cmake_version then
        return nil
    end
    local builder = string_builder()

    -- local min_cmake_version_str = utils.table.map(cmake.m_min_cmake_version, function(value)
    --     return tostring(value)
    -- end)
    -- builder:append(table.concat(min_cmake_version_str, "."))
    builder:append(table.concat(cmake.m_min_cmake_version, "."))

    if cmake.m_max_cmake_version then
        -- local max_cmake_version_str = utils.table.map(cmake.m_max_cmake_version, function(value)
        --     return tostring(value)
        -- end)
        -- builder:append("...", table.concat(max_cmake_version_str, "."))
        builder:append("...", table.concat(cmake.m_max_cmake_version, "."))
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
            error("Minimum cmake version can not be bigger than maximum cmake version."
                .. " Check your cmake version configurations!")
        end
    end
end

cmake.generator.add_action({
    kind = "cmake-version",
    func = function(builder, context)
        builder:append_line("cmake_minimum_required(VERSION ", context.get_version(), " FATAL_ERROR)")
    end,
    context = {
        get_version = cmake.get_version,
    },
})

---@param variable string
---@param value string | boolean
---@param parent_scope boolean | nil
function cmake.set(variable, value, parent_scope)
    if value == true then
        value = "TRUE"
    elseif value == false then
        value = "FALSE"
    end

    cmake.generator.add_action({
        kind = "cmake-set",
        func = function(builder, context)
            builder:append("set(", context.variable, " ", context.value)
            if context.parent_scope then
                builder:append(" PARENT_SCOPE")
            end
            builder:append_line(")")
        end,
        context = {
            variable = variable,
            value = value,
            parent_scope = parent_scope or false
        }
    })
end

cmake.generator.optimizer.add_strat("cmake-set", function(iter)
    ---@type table<string, integer>
    local t = {}

    while iter:current() do
        local current = iter:current()

        local key = current.context.variable .. "_parent-scope:" .. tostring(current.context.parent_scope)
        local index = t[key]
        if index ~= nil then
            iter:pop(index)
        end

        t[key] = iter:index()

        if not iter:next_is_same() then
            return
        end

        iter:increment()
    end
end)
