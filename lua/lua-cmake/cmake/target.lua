local ClassSystem = require("lua-cmake.third_party.derFreemaker.ClassSystem")

---@class lua-cmake.target
local target = {}

---@return string
---@diagnostic disable-next-line: missing-return
function target:get_name() end
target.get_name = ClassSystem.IsInterface

---@return string
---@diagnostic disable-next-line: missing-return
function target:get_kind() end
target.get_kind = ClassSystem.IsInterface

---@return string[]
---@diagnostic disable-next-line: missing-return
function target:get_deps() end
target.get_deps = ClassSystem.IsInterface

---@return string
---@diagnostic disable-next-line: missing-return
function target:generate_cmake() end
target.generate_cmake = ClassSystem.IsInterface

return interface("lua-cmake.target", target)
