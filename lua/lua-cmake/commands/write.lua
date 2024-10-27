---@class lua-cmake
local cmake = _G.cmake

---@param ... string
function cmake.write(...)
    local str = { ... }
    if #str == 0 then
        return
    end

    cmake.generator.add_action({
        kind = "write",
        ---@param context { str: string[] }
        func = function(builder, context)
            builder:append(table.unpack(context.str))
        end,
        context = {
            str = str
        }
    })
end

---@param ... string
function cmake.write_line(...)
    local str = { ... }
    if #str == 0 then
        return
    end

    cmake.generator.add_action({
        kind = "write_line",
        ---@param context { str: string[] }
        func = function(builder, context)
            builder:append_line(table.unpack(context.str))
        end,
        context = {
            str = str
        }
    })
end
