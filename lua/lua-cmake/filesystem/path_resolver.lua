---@type lfs
local lfs = require("lfs")
local utils = require("lua-cmake.utils")

---@class lua-cmake.filesystem.path_resolver
local path_resolver = {}

---@nodiscard
---@param path_str string
---@param absolute boolean | nil default is false
---@return string
function path_resolver.resolve_path(path_str, absolute)
    local path = utils.path.new(path_str)

    if not path:is_absolute() then
        local current_dir = lfs.currentdir():gsub("\\", "/")
        if current_dir ~= cmake.project_dir or absolute then
            path = utils.path.new(current_dir .. "/" .. path:to_string())
        end
    end

    path_str = path:to_string()
    if not absolute then
        local pos = path_str:find(cmake.project_dir, nil, true)
        if pos then
            path_str = path_str:sub(pos + cmake.project_dir:len() + 1)
        end
    end

    return path_str
end

---@param paths string[]
---@return string[]
function path_resolver.resolve_paths(paths)
    local resolved_paths = {}
    for index, path in ipairs(paths) do
        resolved_paths[index] = path_resolver.resolve_path(path)
    end
    return resolved_paths
end

---@param paths string[]
function path_resolver.resolve_paths_implace(paths)
    for index, path in ipairs(paths) do
        paths[index] = path_resolver.resolve_path(path)
    end
end

return path_resolver
