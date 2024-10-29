---@class lua-cmake
local cmake = _G.cmake

local kind = "cmake.add_compile_options"

local global_compile_options = {}
---@param ... string
function cmake.add_compile_options(...)
    local options = { ... }
    if #options == 0 then
        return
    end

    cmake.generator.add_action({
        kind = kind,
        ---@param context { options: string[], compile_options: table<string, true> }
        func = function(builder, context)
            builder:append_line("add_compile_options(")
            for _, option in ipairs(context.options) do
                builder:append_indent()
                    :append_line(option)
            end
            builder:append_line(")")
        end,
        context = {
            options = options,

            compile_options = global_compile_options
        }
    })
end

---@param value lua-cmake.gen.action<{ options: string[], compile_options: table<string, true> }>
cmake.generator.optimizer.add_strat(kind, function(iter, value)
    local changed = false

    for index, option in ipairs(value.context.options) do
        if option:find("${", nil, true) then
            goto continue
        end

        if value.context.compile_options[option] then
            value.context.options[index] = nil
            changed = true
            goto continue
        end

        value.context.compile_options[option] = true
        ::continue::
    end

    if not changed then
        return
    end

    if #value.context.options == 0 then
        iter:remove_current()
        return
    end

    local i = 1
    for index, option in pairs(value.context.options) do
        value.context.options[index] = nil
        value.context.options[i] = option
        i = i + 1
    end
end)
