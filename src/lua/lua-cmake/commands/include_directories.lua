---@class lua-cmake
local cmake = _G.cmake

local kind = "cmake.include_directories"

local global_include_directories = {}
---@param ... string
function cmake.include_directories(...)
    local dirs = { ... }
    if #dirs == 0 then
        return
    end

    cmake.generator.add_action({
        kind = kind,
        ---@param context { dirs: string[], include_directories: table<string, true> }
        func = function(builder, context)
            if #context.dirs == 1 then
                builder:append_line("include_directories(", context.dirs[1], ")")
                return
            end

            builder:append_line("include_directories(")
            for _, dir in ipairs(context.dirs) do
                builder:append_indent()
                    :append_line(dir)
            end
            builder:append_line(")")
        end,
        context = {
            dirs = dirs,

            include_directories = global_include_directories
        }
    })
end

---@param value lua-cmake.gen.action.config<{ dirs: string[], include_directories: table<string, true> }>
cmake.generator.optimizer.add_strat(kind, function(iter, value)
    local changed = false

    for index, dir in ipairs(value.context.dirs) do
        if dir:find("${", nil, true) then
            goto continue
        end

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
