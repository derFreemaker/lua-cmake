---@class lua-cmake.gen.action.config<T> : { kind: string, func: (fun(writer: lua-cmake.utils.string_builder, context: T)), context: T, modify_indent_before: integer | nil, modify_indent_after: integer | nil }

---@class lua-cmake.gen.action : object
---@field private m_generator lua-cmake.gen.generator
---@field id integer
---@field config lua-cmake.gen.action.config<any>
---@overload fun(config: lua-cmake.gen.action.config, generator: lua-cmake.gen.generator) : lua-cmake.gen.action
local action = {}

---@private
---@param config lua-cmake.gen.action.config<any>
---@param generator lua-cmake.gen.generator
function action:__init(config, generator)
    self.m_generator = generator

    self.id = generator.generate_id()
    print("created action: " .. tostring(self.id))

    self.config = config
end

function action:remove()
    self.m_generator.remove_action(self.id)
end

return class("lua-cmake.gen.action", action)
