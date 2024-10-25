---@class lua-cmake
local cmake = _G.cmake

local kind = "cmake.add_definitions"

local global_definitions = {}
---@param ... { [1]: string, [2]: string | nil }
function cmake.add_definitions(...)
    local definitions = { ... }
    if #definitions == 0 then
        return
    end

    cmake.generator.add_action({
        kind = kind,
        ---@param context { definitions: { [1]: string, [2]: string | nil }[], global_definitions: table<string, true> }
        func = function(writer, context)
            if #context.definitions == 1 then
                writer:write("add_definitions(", definitions[1][1])
                if definitions[1][2] then
                    writer:write("=", definitions[1][2])
                end
                writer:write_line(")")
            else
                writer:write_line("add_definitions(")
                for _, definition in ipairs(context.definitions) do
                    writer
                        :write_indent()
                        :write(definition[1])

                    if definition[2] then
                        writer:write("=", definition[2])
                    end

                    writer:write_line()
                end
                writer:write_line(")")
            end
        end,
        context = {
            definitions = definitions,

            global_definitions = global_definitions
        }
    })
end

---@param name string
---@param value string | nil
function cmake.add_definition(name, value)
    cmake.add_definitions({ name, value })
end

---@param value lua-cmake.gen.action<{ definitions: { [1]: string, [2]: string | nil }[], global_definitions: table<string, true> }>
cmake.generator.optimizer.add_strat(kind, function(iter, value)
    local changed = false

    for index, definition in ipairs(value.context.definitions) do
        if definition[1]:find("${") or (definition[2] and definition[2]:find("${")) then
            goto continue
        end

        local key = definition[1] .. tostring(definition[2])
        if value.context.global_definitions[key] then
            value.context.definitions[index] = nil
            changed = true
            goto continue
        end

        value.context.global_definitions[key] = true
        ::continue::
    end

    if not changed then
        return
    end

    if #value.context.definitions == 0 then
        iter:remove_current()
        return
    end

    local i = 1
    for index, definition in pairs(value.context.definitions) do
        value.context.definitions[index] = nil
        value.context.definitions[i] = definition
        i = i + 1
    end
end)

---@param value lua-cmake.gen.action<{ definitions: { [1]: string, [2]: string | nil }[], global_definitions: table<string, true> }>
cmake.generator.optimizer.add_strat(kind, function(iter, value)
    while iter:next_is_same() do
        iter:increment()

        ---@type lua-cmake.gen.action<{ definitions: { [1]: string, [2]: string | nil }[], global_definitions: table<string, true> }>
        local current = iter:current()
        for _, definition in ipairs(current.context.definitions) do
            table.insert(value.context.definitions, definition)
        end

        iter:remove_current()
    end
end)
