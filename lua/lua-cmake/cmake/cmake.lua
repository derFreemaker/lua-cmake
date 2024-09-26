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
            builder:append("set(", context.variable, " \"", context.value, "\"")
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

        local key = current.context.variable .. tostring(current.context.parent_scope)
        local index = t[key]
        if index ~= nil then
            iter:remove(index)
        end

        t[key] = iter:index()

        if not iter:next_is_same() then
            return
        end

        iter:increment()
    end
end)

---@type table<string, true>
local includes = {}
---@param include string
---@param optional boolean | nil
---@param result_var string | nil
---@param no_policy_scope boolean | nil
function cmake.include(include, optional, result_var, no_policy_scope)
    cmake.generator.add_action({
        kind = "cmake-include",
        func = function(builder, context)
            builder:append("include(\"", context.include, "\"")

            if context.optional then
                builder:append(" OPTIONAL")
            end

            if context.result_var then
                builder:append(" ", context.result_var)
            end

            if context.no_policy_scope then
                builder:append(" NO_POLICY_SCOPE")
            end

            builder:append_line(")")
        end,
        context = {
            include = include,
            optional = optional,
            result_var = result_var,
            no_policy_scope = no_policy_scope,

            includes = includes
        }
    })
end

cmake.generator.optimizer.add_strat("cmake-include", function(iter)
    ---@type table
    local context = iter:current().context
    local key = context.include ..
        tostring(context.optional) .. tostring(context.result_var) .. tostring(context.no_policy_scope)
    if context.includes[key] then
        iter:remove_current()
    end

    context.includes[key] = true
end)

---@type table<string, true>
local include_directories = {}
---@param ... string
function cmake.include_directories(...)
    local dirs = {...}
    if #dirs == 0 then
        return
    end

    cmake.generator.add_action({
        kind = "cmake-include_directories",
        func = function (builder, context)
            builder:append_line("include_directories(")
            for _, dir in ipairs(context.dirs) do
                builder:append_line("    \"", dir, "\"")
            end
            builder:append_line(")")
        end,
        context = {
            dirs = dirs,

            include_directories = include_directories
        }
    })
end

cmake.generator.optimizer.add_strat("cmake-include_directories", function(iter, value)
    local changed = false

    for index, dir in ipairs(value.context.dirs) do
        if value.context.include_directories[dir] then
            value.context.dirs[index] = nil
            changed = true
            goto continue
        end

        value.context.include_directories[dir] = true
        ::continue::
    end

    if not changed then
        return
    end

    if #value.context.dirs == 0 then
        iter:remove_current()
        return
    end

    local i = 1
    for index, dir in pairs(value.context.dirs) do
        value.context.dirs[index] = nil
        value.context.dirs[i] = dir
        i = i + 1
    end
end)

---@class lua-cmake.target.options.compile_definition
---@field items { name: string, value: string | nil }[]
---@field type "interface" | "private" | "public"

---@param target string
---@param compile_definitions lua-cmake.target.options.compile_definition[]
function cmake.target_compile_definitions(target, compile_definitions)
    cmake.generator.add_action({
        kind = "cmake-target_compile_definitions",
        ---@param context { target: string, definitions: lua-cmake.target.options.compile_definition[] }
        func = function(builder, context)
            if #context.definitions == 0 then
                return
            end

            builder:append_line("target_compile_definitions(", context.target)

            for _, definition in ipairs(context.definitions) do
                builder:append_line("    ", definition.type:upper())
                for _, item in pairs(definition.items) do
                    builder:append("        ", item.name)
                    if item.value ~= nil then
                        builder:append("=", item.value)
                    end
                    builder:append_line()
                end
            end
            builder:append_line(")")
        end,
        context = {
            target = target,
            definitions = compile_definitions
        }
    })
end
