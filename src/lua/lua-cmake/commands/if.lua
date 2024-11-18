---@class lua-cmake
local cmake = _G.cmake

local kind = "cmake.if_statement"

---@param condition string
---@param body fun()
---@return lua-cmake.if.elses
function cmake._if(condition, body)
    cmake.generator.add_action({
        kind = kind,
        ---@param context { condition: string }
        func = function(builder, context)
            builder:append_line("if(", context.condition, ")")
        end,
        context = {
            condition = condition
        },
        modify_indent_after = 1
    })

    if body then
        body()
    end

    local _endif_action = {
        kind = kind .. "_end",
        func = function(builder)
            builder:append_line("endif()")
        end,
        modify_indent_before = -1,
    }
    local end_action = cmake.generator.add_action(_endif_action)

    ---@class lua-cmake.if.elses
    local elses = {}

    ---@param elseif_condition string
    ---@param elseif_body fun()
    function elses._elseif(elseif_condition, elseif_body)
        end_action:remove()
        cmake.generator.add_action({
            kind = kind .. "_elseif",
            ---@param context { condition: string }
            func = function(builder, context)
                builder:append_line("elseif(", context.condition, ")")
            end,
            context = {
                condition = elseif_condition
            },
            modify_indent_before = -1,
            modify_indent_after = 1,
        })

        if elseif_body then
            elseif_body()
        end

        end_action = cmake.generator.add_action(_endif_action)

        return elses
    end

    ---@param else_body fun()
    function elses._else(else_body)
        end_action:remove()
        cmake.generator.add_action({
            kind = kind .. "_else",
            ---@param context { condition: string }
            func = function(builder, context)
                builder:append_line("else()")
            end,
            modify_indent_before = -1,
            modify_indent_after = 1,
        })

        if else_body then
            else_body()
        end

        end_action = cmake.generator.add_action(_endif_action)
    end

    return elses
end

---@param value lua-cmake.gen.action.config<{ condition: string }>
cmake.generator.optimizer.add_strat(kind, function(iter, value)
    if iter:next_is(kind .. "_end") then
        iter:remove_current()
        iter:remove_next()
        return
    end

    if iter:next_is(kind .. "_else") then
        if value.context.condition:sub(1,3) == "NOT" then
            local trim = 4
            if value.context.condition:sub(4, 4) == " " then
                trim = 5
            end
            value.context.condition = value.context.condition:sub(trim)
        else
            value.context.condition = "NOT " .. value.context.condition
        end
        iter:remove_next()
    end

    --//TODO: handle next kind elseif
    -- if iter:next_is(kind .. "_elseif") then
    -- end
end)
