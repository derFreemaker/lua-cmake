---@class lua-cmake
local cmake = _G.cmake

local global_includes = {}
---@param include string
---@param optional boolean | nil
---@param result_var string | nil
---@param no_policy_scope boolean | nil
function cmake.include(include, optional, result_var, no_policy_scope)
    cmake.generator.add_action({
        kind = "cmake-include",
        ---@param context { include: string, optional: boolean, result_var: boolean, no_policy_scope: boolean, includes: table<string, true> }
        func = function(builder, context)
            builder:write("include(\"", context.include, "\"")

            if context.optional then
                builder:write(" OPTIONAL")
            end

            if context.result_var then
                builder:write(" ", context.result_var)
            end

            if context.no_policy_scope then
                builder:write(" NO_POLICY_SCOPE")
            end

            builder:write_line(")")
        end,
        context = {
            include = include,
            optional = optional or false,
            result_var = result_var or false,
            no_policy_scope = no_policy_scope or false,

            includes = global_includes
        }
    })
end

---@param value lua-cmake.gen.action<{ include: string, optional: boolean, result_var: boolean, no_policy_scope: boolean, includes: table<string, true> }>
cmake.generator.optimizer.add_strat("cmake-include", function(iter, value)
    if value.context.include:find("${") then
        return
    end

    local key = value.context.include ..
        tostring(value.context.optional) .. tostring(value.context.result_var) .. tostring(value.context.no_policy_scope)
    if value.context.includes[key] then
        iter:remove_current()
    end

    value.context.includes[key] = true
end)
