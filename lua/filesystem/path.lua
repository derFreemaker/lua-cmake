---@type lfs
local lfs = require("lfs")

---@type lua-cmake.Utils.String
local String = require("lua-cmake.lua.utils.string")
---@type lua-cmake.Utils.Table
local Table = require("lua-cmake.lua.utils.table")

---@param str string
---@return string str
local function formatStr(str)
    str = str:gsub("\\", "/")
    return str
end

---@class lua-cmake.FileSystem.Path : object
---@field private m_nodes string[]
---@overload fun(pathOrNodes: (string | string[])?) : lua-cmake.FileSystem.Path
local Path = {}

---@param str string
---@return boolean isNode
function Path.Static__IsNode(str)
    if str:find("/") then
        return false
    end

    return true
end

---@private
---@param pathOrNodes string | string[]
function Path:__init(pathOrNodes)
    if not pathOrNodes then
        self.m_nodes = {}
        return
    end

    if type(pathOrNodes) == "string" then
        pathOrNodes = formatStr(pathOrNodes)
        pathOrNodes = String.Split(pathOrNodes, "/")
    end

    local length = #pathOrNodes
    local node = pathOrNodes[length]
    if node ~= "" and not node:find("^.+%..+$") then
        pathOrNodes[length + 1] = ""
    end

    self.m_nodes = pathOrNodes

    self:Normalize()
end

---@return string path
function Path:ToString()
    return String.Join(self.m_nodes, "/")
end

---@private
Path.__tostring = Path.ToString

---@return boolean
function Path:IsEmpty()
    return #self.m_nodes == 0 or (#self.m_nodes == 2 and self.m_nodes[1] == "" and self.m_nodes[2] == "")
end

---@return boolean
function Path:IsFile()
    return self.m_nodes[#self.m_nodes] ~= ""
end

---@return boolean
function Path:IsDir()
    return self.m_nodes[#self.m_nodes] == ""
end

function Path:Exists()
    local path = self:ToString()
    return lfs.attributes(path) ~= nil
end

---@return string
function Path:GetParentFolder()
    local copy = Table.Copy(self.m_nodes)
    local length = #copy

    if length > 0 then
        if length > 1 and copy[length] == "" then
            copy[length] = nil
            copy[length - 1] = ""
        else
            copy[length] = nil
        end
    end

    return String.Join(copy, "/")
end

---@return lua-cmake.FileSystem.Path
function Path:GetParentFolderPath()
    local copy = self:Copy()
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
function Path:GetFileName()
    if not self:IsFile() then
        error("path is not a file: " .. self:ToString())
    end

    return self.m_nodes[#self.m_nodes]
end

---@return string fileExtension
function Path:GetFileExtension()
    if not self:IsFile() then
        error("path is not a file: " .. self:ToString())
    end

    local fileName = self.m_nodes[#self.m_nodes]

    local _, _, extension = fileName:find("^.+(%..+)$")
    return extension
end

---@return string fileStem
function Path:GetFileStem()
    if not self:IsFile() then
        error("path is not a file: " .. self:ToString())
    end

    local fileName = self.m_nodes[#self.m_nodes]

    local _, _, stem = fileName:find("^(.+)%..+$")
    return stem
end

---@return lua-cmake.FileSystem.Path
function Path:Normalize()
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

---@param path string
---@return lua-cmake.FileSystem.Path
function Path:Append(path)
    path = formatStr(path)
    local newNodes = String.Split(path, "/")

    for _, value in ipairs(newNodes) do
        self.m_nodes[#self.m_nodes + 1] = value
    end

    self:Normalize()

    return self
end

---@param path string
---@return lua-cmake.FileSystem.Path
function Path:Extend(path)
    local copy = self:Copy()
    return copy:Append(path)
end

---@return lua-cmake.FileSystem.Path
function Path:Copy()
    local copyNodes = Table.Copy(self.m_nodes)
    return Path(copyNodes)
end

return class("lua-cmake.FileSystem.Path", Path)
