---@class lua-cmake
local cmake = _G.cmake

local kind = "cmake.set"

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
        kind = kind,
        ---@param context { variable: string, value: string, parent_scope: boolean }
        func = function(builder, context)
            builder:write("set(", context.variable, " \"", context.value, "\"")
            if context.parent_scope then
                builder:write(" PARENT_SCOPE")
            end
            builder:write_line(")")
        end,
        context = {
            variable = variable,
            value = value,
            parent_scope = parent_scope or false
        }
    })
end

cmake.generator.optimizer.add_strat(kind, function(iter)
    ---@type table<string, integer>
    local t = {}

    while iter:current() do
        ---@type lua-cmake.gen.action<{ variable: string, value: string, parent_scope: boolean }>
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
