---@class lua-cmake
local cmake = _G.cmake

local kind = "cmake.include"

---@param include string
---@param optional boolean | nil
---@param result_var string | nil
---@param no_policy_scope boolean | nil
function cmake.include(include, optional, result_var, no_policy_scope)
    cmake.generator.add_action({
        kind = kind,
        ---@param context { include: string, optional: boolean, result_var: boolean, no_policy_scope: boolean, includes: table<string, true> }
        func = function(builder, context)
            builder:write("include(", context.include)

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
        }
    })
end
