local Utils = require("tools.utils")

---@class Tools.FileSystem
local FileSystem = {}

---@param str string
---@return string str
local function formatStr(str)
	str = str:gsub("\\", "/")
	return str
end

---@class Tools.FileSystem.Path
---@field private m_nodes string[]
local Path = {}

---@param str string
---@return boolean isNode
function Path.IsNode(str)
	if str:find("/") then
		return false
	end

	return true
end

---@package
---@param pathOrNodes string | string[]
---@return Tools.FileSystem.Path
function Path.new(pathOrNodes)
	local instance = {}
	if not pathOrNodes then
		instance.m_nodes = {}
		return setmetatable(instance, Path)
	end

	if type(pathOrNodes) == "string" then
		pathOrNodes = formatStr(pathOrNodes)
		pathOrNodes = Utils.SplitStr(pathOrNodes, "/")
	end

	local length = #pathOrNodes
	local node = pathOrNodes[length]
	if node and node ~= "" and not node:find("^.+%..+$") then
		pathOrNodes[length + 1] = ""
	end

	instance.m_nodes = pathOrNodes
	instance = setmetatable(instance, { __index = Path })

	return instance
end

---@return string path
function Path:ToString()
	self:Normalize()
	return Utils.JoinStr(self.m_nodes, "/")
end

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
	return os.rename(path, path) and true or false
end

---@return boolean
function Path:Create()
	if self:Exists() then
		return true
	end

	if self:IsDir() then
		return FileSystem.createFolder(self:ToString())
	end

	if self:IsFile() then
		local file = FileSystem.OpenFile(self:ToString(), "w")
		file:write("")
		file:close()
	end

	return false
end

---@return boolean
function Path:IsAbsolute()
	return self.m_nodes[1] == ""
end

---@return Tools.FileSystem.Path
function Path:Absolute()
	if self:IsAbsolute() then
		return self:Copy()
	end

	local copy = Utils.CopyTable(self.m_nodes)
	for i = 1, #copy, 1 do
		copy[i] = copy[i + 1]
	end
	copy[1] = ""

	return Path.new(copy)
end

---@return boolean
function Path:IsRelative()
	if not self.m_nodes[1] then
		return false
	end

	return self.m_nodes[1] ~= "" and not self.m_nodes[1]:find(":")
end

---@return Tools.FileSystem.Path
function Path:Relative()
	if self:IsRelative() then
		return self:Copy()
	end

	local copy = { "" }
	for i = 1, #self.m_nodes, 1 do
		copy[i + 1] = self.m_nodes[i]
	end

	return Path.new(copy)
end

---@return string
function Path:GetParentFolder()
	local copy = Utils.CopyTable(self.m_nodes)
	local length = #copy

	if length > 0 then
		if length > 1 and copy[length] == "" then
			copy[length] = nil
			copy[length - 1] = ""
		else
			copy[length] = nil
		end
	end

	return Utils.JoinStr(copy, "/")
end

---@return Tools.FileSystem.Path
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

---@return Tools.FileSystem.Path
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

	if newNodes[1] then
		newNodes[1] = newNodes[1]:gsub("@", "")
	end

	self.m_nodes = newNodes
	return self
end

---@param path string
---@return Tools.FileSystem.Path
function Path:Append(path)
	path = formatStr(path)
	local newNodes = Utils.SplitStr(path, "/")

	for _, value in ipairs(newNodes) do
		self.m_nodes[#self.m_nodes + 1] = value
	end

	self:Normalize()

	return self
end

---@param path string
---@return Tools.FileSystem.Path
function Path:Extend(path)
	local copy = self:Copy()
	return copy:Append(path)
end

---@return Tools.FileSystem.Path
function Path:Copy()
	local copyNodes = Utils.CopyTable(self.m_nodes)
	return Path.new(copyNodes)
end

------------------------------------------
--- FileSystem
------------------------------------------

---@param str string?
---@return Tools.FileSystem.Path
function FileSystem.Path(str)
	if str == nil then
		str = ""
	end
	return Path.new(str)
end

---@param path string
---@param mode openmode
---@return file*
function FileSystem.OpenFile(path, mode)
	local file = io.open(path, mode)
	if not file then
		error('unable to open file: ' .. path)
	end
	return file
end

---@return string
function FileSystem.GetCurrentDirectory()
	local source = debug.getinfo(2, 'S').source:gsub('\\', '/'):gsub('@', '')
	local slashPos = source:reverse():find('/')
	if not slashPos then
		return ""
	end
	local length = source:len()
	local currentPath = source:sub(0, length - slashPos)
	return currentPath
end

---@return string
function FileSystem.GetCurrentWorkingDirectory()
	local cmd = io.popen("cd")
	if not cmd then
		error("unable to get current directory")
	end
	local path = ""
	for line in cmd:lines() do
		if line ~= "" then
			path = path .. line
		end
	end
	cmd:close()
	return path
end

---@param path string
---@return string[]
function FileSystem.GetDirectories(path)
	local command = 'dir "' .. path .. '" /ad /b'
	local result = io.popen(command)
	if not result then
		error('unable to run command: ' .. command)
	end
	---@type string[]
	local children = {}
	for line in result:lines() do
		table.insert(children, line)
	end
	return children
end

---@param path string
---@return string[]
function FileSystem.GetFiles(path)
	local command = 'dir "' .. path .. '" /a-d /b'
	local result = io.popen(command)
	if not result then
		error('unable to run command: ' .. command)
	end
	---@type string[]
	local children = {}
	for line in result:lines() do
		table.insert(children, line)
	end
	return children
end

---@param path string
---@return boolean
function FileSystem.createFolder(path)
	local success = os.execute("mkdir \"" .. path .. "\"")
	return success or false
end

return FileSystem