---@type lfs
local lfs = require("lfs")
local utils_path = require("lua-cmake.third_party.derFreemaker.utils.bin.path")

local project_dir = lfs.currentdir():gsub("\\", "/")
if not project_dir then
    error("unable to get lfs.currentdir()")
end
local project_dir_len = project_dir:len()

---@class lua-cmake.filesystem.path_resolver
local path_resolver = {}

---@nodiscard
---@param path_str string
---@return string
function path_resolver.resolve_path(path_str)
    local path = utils_path.new(path_str)

    if not path:is_absolute() then
        local current_dir = lfs.currentdir():gsub("\\", "/")
        if current_dir == project_dir then
            return path_str
        end

        path = utils_path.new(current_dir .. "/" .. path:to_string())
    end

    path_str = path:to_string()
    local pos = path_str:find(project_dir, nil, true)
    if pos then
        path_str = path_str:sub(pos + project_dir_len + 1)
    end

    return path_str
end

---@param paths string[]
---@return string[]
function path_resolver.resolve_paths(paths)
    for index, path in ipairs(paths) do
        paths[index] = path_resolver.resolve_path(path)
    end

    return paths
end

return path_resolver
