---@class class-system
local class = {}

---@param obj any
---@return class-system.type | nil
function class.typeof(obj)
    if not type(obj) == "table" then
        return nil
    end

    ---@type class-system.metatable
    local metatable = getmetatable(obj)
    if not metatable then
        return nil
    end

    return metatable.type
end

---@param obj any
---@return string
function class.nameof(obj)
    local type_info = class.typeof(obj)
    if not type_info then
        return type(obj)
    end

    return type_info.name
end

---@param obj object
---@return class-system.instance | nil
function class.get_instance_data(obj)
    if not class.is_class(obj) then
        return
    end

    ---@type class-system.metatable
    local metatable = getmetatable(obj)
    return metatable.instance
end

---@param obj any
---@return boolean isClass
function class.is_class(obj)
    if type(obj) ~= "table" then
        return false
    end

    ---@type class-system.metatable
    local metatable = getmetatable(obj)

    if not metatable then
        return false
    end

    if not metatable.type then
        return false
    end

    if not metatable.type.name then
        return false
    end

    return true
end

---@param obj any
---@param className string
---@return boolean hasBaseClass
function class.has_base(obj, className)
    if not class.is_class(obj) then
        return false
    end

    ---@type class-system.metatable
    local metatable = getmetatable(obj)

    ---@param type_info class-system.type
    local function hasBase(type_info)
        local typeName = type_info.name
        if typeName == className then
            return true
        end

        if not type_info.base then
            return false
        end

        return hasBase(type_info.base)
    end

    return hasBase(metatable.type)
end

---@param obj any
---@param interfaceName string
---@return boolean hasInterface
function class.has_interface(obj, interfaceName)
    if not class.is_class(obj) then
        return false
    end

    ---@type class-system.metatable
    local metatable = getmetatable(obj)

    ---@param type_info class-system.type
    local function hasInterface(type_info)
        local typeName = type_info.name
        if typeName == interfaceName then
            return true
        end

        for _, value in pairs(type_info.interfaces) do
            if hasInterface(value) then
                return true
            end
        end

        return false
    end

    return hasInterface(metatable.type)
end

return class
