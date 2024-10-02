---@class lua-cmake.cmake
local cmake = _G.cmake

--//TODO: add detection if variable is used since they can change over time and there for not easily optimized out
local global_compile_options = {}
---@param ... string
function cmake.add_compile_options(...)
    local options = { ... }
    if #options == 0 then
        return
    end

    cmake.generator.add_action({
        kind = "cmake-add_compile_options",
        ---@param context { options: string[], compile_options: table<string, true> }
        func = function(writer, context)
            writer:write_line("add_compile_options(")
            for _, option in ipairs(context.options) do
                writer
                    :write_indent()
                    :write_line("\"", option, "\"")
            end
            writer:write_line(")")
        end,
        context = {
            options = options,

            compile_options = global_compile_options
        }
    })
end

---@param value lua-cmake.gen.action<{ options: string[], compile_options: table<string, true> }>
cmake.generator.optimizer.add_strat("cmake-add_compile_options", function(iter, value)
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
