---@class Freemaker.ClassSystem.Utils
local Utils = {}

-- ############ Class ############ --

---@class Freemaker.ClassSystem.Utils.Class
local Class = {}

---@param obj any
---@return Freemaker.ClassSystem.Type?
function Class.Typeof(obj)
    if not type(obj) == "table" then
        return nil
    end

    local metatable = getmetatable(obj) or {}
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
