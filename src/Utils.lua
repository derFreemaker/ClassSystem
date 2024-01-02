---@class Freemaker.ClassSystem.Utils
local Utils = {}

-- ############ Table ############ --

---@class Freemaker.ClassSystem.Utils.Table
local Table = {}

---@param obj table?
---@param seen table[]
---@return table?
local function copyTable(obj, copy, seen)
    if obj == nil then return nil end
    if seen[obj] then return seen[obj] end

    seen[obj] = copy
    setmetatable(copy, copyTable(getmetatable(obj), {}, seen))

    for key, value in next, obj, nil do
        key = (type(key) == "table") and copyTable(key, {}, seen) or key
        value = (type(value) == "table") and copyTable(value, {}, seen) or value
        rawset(copy, key, value)
    end

    return copy
end

---@generic TTable
---@param t TTable
---@return TTable table
function Table.Copy(t)
    return copyTable(t, {}, {})
end

---@param t table
---@param ignoreProperties string[]?
function Table.Clear(t, ignoreProperties)
    if not ignoreProperties then
        ignoreProperties = {}
    end
    for key, _ in next, t, nil do
        if not Table.Contains(ignoreProperties, key) then
            t[key] = nil
        end
    end
    setmetatable(t, nil)
end

---@param t table
---@param value any
---@return boolean
function Table.Contains(t, value)
    for _, tValue in pairs(t) do
        if value == tValue then
            return true
        end
    end
    return false
end

---@param t table
---@param key any
---@return boolean
function Table.ContainsKey(t, key)
    if t[key] ~= nil then
        return true
    end
    return false
end

Utils.Table = Table

-- ############ Table ############ --

-- ############ String ############ --

---@class Freemaker.ClassSystem.Utils.String
local String = {}

---@param str string
---@param pattern string
---@return string?, integer
local function findNext(str, pattern)
    local found = str:find(pattern, 0, true)
    if found == nil then
        return nil, 0
    end
    return str:sub(0, found - 1), found - 1
end

---@param str string?
---@param sep string?
---@return string[]
function String.Split(str, sep)
    if str == nil then
        return {}
    end

    local strLen = str:len()
    local sepLen

    if sep == nil then
        sep = "%s"
        sepLen = 2
    else
        sepLen = sep:len()
    end

    local tbl = {}
    local i = 0
    while true do
        i = i + 1
        local foundStr, foundPos = findNext(str, sep)

        if foundStr == nil then
            tbl[i] = str
            return tbl
        end

        tbl[i] = foundStr
        str = str:sub(foundPos + sepLen + 1, strLen)
    end
end

Utils.String = String

-- ############ String ############ --

-- ############ Value ############ --

---@class Freemaker.ClassSystem.Utils.Value
local Value = {}

---@generic T
---@param value T
---@return T
function Value.Copy(value)
    local typeStr = type(value)

    if typeStr == "table" then
        return Table.Copy(value)
    end

    return value
end

Utils.Value = Value

-- ############ Value ############ --

-- ############ Class ############ --

---@class Freemaker.ClassSystem.Utils.Class
local Class = {}

---@param obj any
---@return Freemaker.ClassSystem.Type?
function Class.Typeof(obj)
    if not type(obj) == "table" then
        return nil
    end

    local metatable = getmetatable(obj)
    return metatable.Type
end

---@param obj any
---@return string
function Class.Nameof(obj)
    local typeInfo = Class.Typeof(obj)
    if not typeInfo then
        return type(obj)
    end

    return typeInfo.Name
end

---@param obj object
---@return Freemaker.ClassSystem.Instance?
function Class.GetInstanceData(obj)
    if not Class.IsClass(obj) then
        return
    end

    ---@type Freemaker.ClassSystem.Metatable
    local metatable = getmetatable(obj)
    return metatable.Instance
end

---@param obj any
---@return boolean isClass
function Class.IsClass(obj)
    if type(obj) ~= "table" then
        return false
    end

    local metatable = getmetatable(obj)

    if not metatable then
        return false
    end

    if not metatable.Type then
        return false
    end

    if not metatable.Type.Name then
        return false
    end

    return true
end

---@param obj any
---@param className string
---@return boolean hasBaseClass
function Class.HasBase(obj, className)
    if not Class.IsClass(obj) then
        return false
    end

    local metatable = getmetatable(obj)

    ---@param typeInfo Freemaker.ClassSystem.Type
    local function hasTypeBase(typeInfo)
        local typeName = typeInfo.Name
        if typeName == className then
            return true
        end

        if typeName ~= "object" then
            return hasTypeBase(typeInfo.Base)
        end

        return false
    end

    return hasTypeBase(metatable.Type)
end

Utils.Class = Class

-- ############ Class ############ --

return Utils
