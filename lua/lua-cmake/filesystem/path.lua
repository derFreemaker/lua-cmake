---@type lfs
local lfs = require("lfs")

---@type lua-cmake.utils.string
local utils_string = require("lua-cmake.lua.utils.string")
---@type lua-cmake.utils.table
local utils_table = require("lua-cmake.lua.utils.table")

---@param str string
---@return string str
local function formatStr(str)
    str = str:gsub("\\", "/")
    return str
end

---@class lua-cmake.filesystem.path : object
---@field private m_nodes string[]
---@overload fun(pathOrNodes: (string | string[])?) : lua-cmake.filesystem.path
local path = {}

---@param str string
---@return boolean isNode
function path.Static__is_node(str)
    if str:find("/") then
        return false
    end

    return true
end

---@private
---@param pathOrNodes string | string[]
function path:__init(pathOrNodes)
    if not pathOrNodes then
        self.m_nodes = {}
        return
    end

    if type(pathOrNodes) == "string" then
        pathOrNodes = formatStr(pathOrNodes)
        pathOrNodes = utils_string.split(pathOrNodes, "/")
    end

    local length = #pathOrNodes
    local node = pathOrNodes[length]
    if node ~= "" and not node:find("^.+%..+$") then
        pathOrNodes[length + 1] = ""
    end

    self.m_nodes = pathOrNodes

    self:normalize()
end

---@return string path
function path:to_string()
    return utils_string.join(self.m_nodes, "/")
end

---@private
path.__tostring = path.to_string

---@return boolean
function path:empty()
    return #self.m_nodes == 0 or (#self.m_nodes == 2 and self.m_nodes[1] == "" and self.m_nodes[2] == "")
end

---@return boolean
function path:file()
    return self.m_nodes[#self.m_nodes] ~= ""
end

---@return boolean
function path:dir()
    return self.m_nodes[#self.m_nodes] == ""
end

function path:exists()
    local path_str = self:to_string()
    return lfs.attributes(path_str) ~= nil
end

---@return string
function path:get_parent_folder()
    local copy = utils_table.copy(self.m_nodes)
    local length = #copy

    if length > 0 then
        if length > 1 and copy[length] == "" then
            copy[length] = nil
            copy[length - 1] = ""
        else
            copy[length] = nil
        end
    end

    return utils_string.join(copy, "/")
end

---@return lua-cmake.filesystem.path
function path:get_parent_folder_path()
    local copy = self:copy()
    local length = #copy.m_nodes

    if length > 0 then
        if length > 1 and copy.m_nodes[length] == "" then
            copy.m_nodes[length] = nil
            copy.m_nodes[length - 1] = ""
        else
            copy.m_nodes[length] = nil
        end
    end

    return copy
end

---@return string fileName
function path:get_file_name()
    if not self:file() then
        error("path is not a file: " .. self:to_string())
    end

    return self.m_nodes[#self.m_nodes]
end

---@return string fileExtension
function path:get_file_extension()
    if not self:file() then
        error("path is not a file: " .. self:to_string())
    end

    local fileName = self.m_nodes[#self.m_nodes]

    local _, _, extension = fileName:find("^.+(%..+)$")
    return extension
end

---@return string fileStem
function path:get_file_stem()
    if not self:file() then
        error("path is not a file: " .. self:to_string())
    end

    local fileName = self.m_nodes[#self.m_nodes]

    local _, _, stem = fileName:find("^(.+)%..+$")
    return stem
end

---@return lua-cmake.filesystem.path
function path:normalize()
    ---@type string[]
    local newNodes = {}

    for index, value in ipairs(self.m_nodes) do
        if value == "." then
        elseif value == "" then
            if index == 1 or index == #self.m_nodes then
                newNodes[#newNodes + 1] = ""
            end
        elseif value == ".." then
            if index ~= 1 then
                newNodes[#newNodes] = nil
            end
        else
            newNodes[#newNodes + 1] = value
        end
    end

    self.m_nodes = newNodes
    return self
end

---@param path_str string
---@return lua-cmake.filesystem.path
function path:append(path_str)
    path_str = formatStr(path_str)
    local newNodes = utils_string.split(path_str, "/")

    for _, value in ipairs(newNodes) do
        self.m_nodes[#self.m_nodes + 1] = value
    end

    self:normalize()

    return self
end

---@param path_str string
---@return lua-cmake.filesystem.path
function path:extend(path_str)
    local copy = self:copy()
    return copy:append(path_str)
end

---@return lua-cmake.filesystem.path
function path:copy()
    local copyNodes = utils_table.copy(self.m_nodes)
    return path(copyNodes)
end

return class("lua-cmake.FileSystem.Path", path)
