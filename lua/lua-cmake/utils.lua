local utils = require("lua-cmake.third_party.derFreemaker.utils.bin.utils")
---@cast utils Freemaker.utils

---@class lua-cmake.utils : Freemaker.utils
utils = utils
utils.path = require("lua-cmake.filesystem.path")

return utils
