---@class Freemaker.ClassSystem
local Class = {}

---@param obj any
---@return Freemaker.ClassSystem.Type | nil
function Class.Typeof(obj)
    if not type(obj) == "table" then
        return nil
    end

    local metatable = getmetatable(obj)
    if not metatable then
        return nil
    end

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
---@return Freemaker.ClassSystem.Instance | nil
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
    local function hasBase(typeInfo)
        local typeName = typeInfo.Name
        if typeName == className then
            return true
        end

        if not typeInfo.Base then
            return false
        end

        return hasBase(typeInfo.Base)
    end

    return hasBase(metatable.Type)
end

---@param obj any
---@param interfaceName string
---@return boolean hasInterface
function Class.HasInterface(obj, interfaceName)
    if not Class.IsClass(obj) then
        return false
    end

    local metatable = getmetatable(obj)

    ---@param typeInfo Freemaker.ClassSystem.Type
    local function hasInterface(typeInfo)
        local typeName = typeInfo.Name
        if typeName == interfaceName then
            return true
        end

        for _, value in pairs(typeInfo.Interfaces) do
            if hasInterface(value) then
                return true
            end
        end

        return false
    end

    return hasInterface(metatable.Type)
end

return Class
