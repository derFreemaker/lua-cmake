---@class lua-cmake
local cmake = _G.cmake

---@param condition string
---@param body fun()
---@return lua-cmake.if.elses
function cmake._if(condition, body)
    cmake.generator.add_action({
        kind = "cmake-if_statement",
        ---@param context { condition: string }
        func = function(writer, context)
            writer:write_line("if(", context.condition, ")")
        end,
        context = {
            condition = condition
        },
        add_indent_after = true
    })

    if body then
        body()
    end

    local _endif_action = {
        kind = "cmake-if_statement_end",
        func = function(writer)
            writer:write_line("endif()")
        end,
        remove_indent_before = true,
    }
    cmake.generator.add_action(_endif_action)

    ---@class lua-cmake.if.elses
    local elses = {}

    ---@param elseif_condition string
    ---@param elseif_body fun()
    function elses._elseif(elseif_condition, elseif_body)
        cmake.generator.remove_last_action()
        cmake.generator.add_action({
            kind = "cmake-if_statement_elseif",
            ---@param context { condition: string }
            func = function(writer, context)
                writer:write_line("elseif(", context.condition, ")")
            end,
            context = {
                condition = elseif_condition
            },
            remove_indent_before = true,
            add_indent_after = true,
        })

        if elseif_body then
            elseif_body()
        end

        cmake.generator.add_action(_endif_action)

        return elses
    end

    ---@param else_body fun()
    function elses._else(else_body)
        cmake.generator.remove_last_action()
        cmake.generator.add_action({
            kind = "cmake-if_statement_else",
            ---@param context { condition: string }
            func = function(writer, context)
                writer:write_line("else()")
            end,
            remove_indent_before = true,
            add_indent_after = true,
        })

        if else_body then
            else_body()
        end

        cmake.generator.add_action(_endif_action)
    end

    return elses
end

--//TODO: add optimizer strat that removes the if if there are no actions in it.
--// can add 'NOT <condition>' to inverse
---@param value lua-cmake.gen.action<{ condition: string }>
cmake.generator.optimizer.add_strat("cmake-if_statement", function(iter, value)
    if iter:next_is("cmake-if_statement_end") then
        iter:remove_current()
        iter:remove_next()
        return
    end

    if iter:next_is("cmake-if_statement_else") then
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

    -- if iter:next_is("cmake-if_statement_elseif") then
    --     --//TODO: handle next on is elseif
    -- end
end)
