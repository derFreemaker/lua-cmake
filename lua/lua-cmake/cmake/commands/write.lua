---@class lua-cmake.cmake
local cmake = _G.cmake

---@param ... string
function cmake.write(...)
    local str = { ... }
    if #str == 0 then
        return
    end

    cmake.generator.add_action({
        kind = "cmake-write",
        ---@param context { str: string[] }
        func = function(writer, context)
            writer:write(table.unpack(context.str))
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
        kind = "cmake-write",
        ---@param context { str: string[] }
        func = function(writer, context)
            writer:write_line(table.unpack(context.str))
        end,
        context = {
            str = str
        }
    })
end
