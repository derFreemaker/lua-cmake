---@type Freemaker.ClassSystem
local ClassSystem = require("lua-cmake.third_party.derFreemaker.ClassSystem")

---@alias lua-cmake.Target.Kind
---|"library"
---|"executable"

---@class lua-cmake.Target
local Target = {}

---@return string
---@diagnostic disable-next-line: missing-return
function Target:GetName() end
Target.GetName = ClassSystem.IsInterface

---@return lua-cmake.Target.Kind
---@diagnostic disable-next-line: missing-return
function Target:GetKind() end
Target.GetKind = ClassSystem.IsInterface

return interface("lua-cmake.Target", Target)
