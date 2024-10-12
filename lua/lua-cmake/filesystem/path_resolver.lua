---@type lfs
local lfs = require("lfs")

---@return "windows" | "linux"
local function get_os()
    if package.config:sub(1, 1) == '\\' then
        return "windows"
    else
        return "linux"
    end
end

---@class lua-cmake.filesystem.path_resolver
local path_resolver = {}

---@nodiscard
---@param path string
---@param absolute boolean | nil default is false
---@return string
function path_resolver.resolve_path(path, absolute)
    if (get_os() == "windows" and (path:len() < 2 or path:sub(2, 2) ~= ":"))
        or (get_os() == "linux" and (path:len() < 1 or path:sub(1, 1) ~= "/")) then
        local current_dir = lfs.currentdir()
        if not current_dir then
            error("unable to get current dir")
        end
        current_dir = current_dir:gsub("\\", "/")

        if current_dir ~= cmake.project_dir or absolute then
            if path:sub(1, 1) ~= "/" then
                path = current_dir .. "/" .. path
            else
                path = current_dir .. path
            end
        end
    end

    if not absolute then
        local pos = path:find(cmake.project_dir, nil, true)
        if pos then
            path = path:sub(pos + cmake.project_dir:len() + 1)
        end
    end

    return path
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
