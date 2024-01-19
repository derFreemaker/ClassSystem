local Utils = require("tools.Freemaker.bin.utils")

local Configs = require("src.Config")

local InstanceHandler = require("src.Instance")

---@class Freemaker.ClassSystem.MembersHandler
local MembersHandler = {}

---@param typeInfo Freemaker.ClassSystem.Type
function MembersHandler.Initialize(typeInfo)
    typeInfo.Static = {}
    typeInfo.MetaMethods = {}
    typeInfo.Members = {}
end

---@param typeInfo Freemaker.ClassSystem.Type
function MembersHandler.UpdateState(typeInfo)
    local metaMethods = typeInfo.MetaMethods

    typeInfo.HasConstructor = metaMethods.__init ~= nil
    typeInfo.HasDeconstructor = metaMethods.__gc ~= nil
    typeInfo.HasClose = metaMethods.__close ~= nil
    typeInfo.HasIndex = metaMethods.__index ~= nil
    typeInfo.HasNewIndex = metaMethods.__newindex ~= nil
end

function MembersHandler.GetStatic(typeInfo, key)
    local value = rawget(typeInfo.Static, key)

    if value ~= nil then
        return value
    end

    if typeInfo.Base then
        return MembersHandler.GetStatic(typeInfo.Base, key)
    end

    return nil
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param key string
---@param value any
---@return boolean wasFound
local function assignStatic(typeInfo, key, value)
    if rawget(typeInfo.Static, key) ~= nil then
        rawset(typeInfo.Static, key, value)
        return true
    end

    if typeInfo.Base then
        return assignStatic(typeInfo.Base, key, value)
    end

    return false
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param key string
---@param value any
function MembersHandler.SetStatic(typeInfo, key, value)
    if not assignStatic(typeInfo, key, value) then
        rawset(typeInfo.Static, key, value)
    end
end

-------------------------------------------------------------------------------
-- Index & NewIndex
-------------------------------------------------------------------------------

---@param typeInfo Freemaker.ClassSystem.Type
---@return fun(obj: object, key: any) : any value
function MembersHandler.TemplateIndex(typeInfo)
    return function(obj, key)
        if type(key) ~= "string" then
            error("can only use static members in template")
            return {}
        end

        local splittedKey = Utils.String.Split(key, "__")
        if Utils.Table.Contains(splittedKey, "Static") then
            return MembersHandler.GetStatic(typeInfo, key)
        end

        error("can only use static members in template")
    end
end

---@param typeInfo Freemaker.ClassSystem.Type
---@return fun(obj: object, key: any, value: any)
function MembersHandler.TemplateNewIndex(typeInfo)
    return function(obj, key, value)
        if type(key) ~= "string" then
            error("can only use static members in template")
            return
        end

        local splittedKey = Utils.String.Split(key, "__")
        if Utils.Table.Contains(splittedKey, "Static") then
            MembersHandler.SetStatic(typeInfo, key, value)
            return
        end

        error("can only use static members in template")
    end
end

---@param instance Freemaker.ClassSystem.Instance
---@param typeInfo Freemaker.ClassSystem.Type
---@return fun(obj: object, key: any) : any value
function MembersHandler.InstanceIndex(instance, typeInfo)
    return function(obj, key)
        if type(key) == "string" then
            local splittedKey = Utils.String.Split(key, "__")
            if Utils.Table.Contains(splittedKey, "Static") then
                return MembersHandler.GetStatic(typeInfo, key)
            elseif Utils.Table.Contains(splittedKey, "Raw") then
                return rawget(obj, key)
            end
        end

        if typeInfo.HasIndex and not instance.CustomIndexing then
            local value = typeInfo.MetaMethods.__index(obj, key)
            if value ~= Configs.GetNormal then
                return value
            end
        end

        return rawget(obj, key)
    end
end

---@param instance Freemaker.ClassSystem.Instance
---@param typeInfo Freemaker.ClassSystem.Type
---@return fun(obj: object, key: any, value: any)
function MembersHandler.InstanceNewIndex(instance, typeInfo)
    return function(obj, key, value)
        if type(key) == "string" then
            local splittedKey = Utils.String.Split(key, "__")
            if Utils.Table.Contains(splittedKey, "Static") then
                return MembersHandler.SetStatic(typeInfo, key, value)
            elseif Utils.Table.Contains(splittedKey, "Raw") then
                rawset(obj, key, value)
            end
        end

        if typeInfo.HasNewIndex and not instance.CustomIndexing then
            if typeInfo.MetaMethods.__newindex(obj, key, value) ~= Configs.SetNormal then
                return
            end
        end

        rawset(obj, key, value)
    end
end

-------------------------------------------------------------------------------
-- Sort
-------------------------------------------------------------------------------

---@param typeInfo Freemaker.ClassSystem.Type
---@param name string
---@param func function
local function isNormalFunction(typeInfo, name, func)
    if Utils.Table.ContainsKey(Configs.AllMetaMethods, name) then
        typeInfo.MetaMethods[name] = func
        return
    end

    typeInfo.Members[name] = func
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param name string
---@param value any
local function isNormalMember(typeInfo, name, value)
    if type(value) == 'function' then
        isNormalFunction(typeInfo, name, value)
        return
    end

    typeInfo.Members[name] = value
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param name string
---@param value any
local function isStaticMember(typeInfo, name, value)
    typeInfo.Static[name] = value
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param key any
---@param value any
local function sortMember(typeInfo, key, value)
    if type(key) == 'string' then
        local splittedKey = Utils.String.Split(key, '__')
        if Utils.Table.Contains(splittedKey, 'Static') then
            isStaticMember(typeInfo, key, value)
            return
        end

        isNormalMember(typeInfo, key, value)
        return
    end

    typeInfo.Members[key] = value
end

function MembersHandler.Sort(data, typeInfo)
    for key, value in pairs(data) do
        sortMember(typeInfo, key, value)
    end

    MembersHandler.UpdateState(typeInfo)
end

-------------------------------------------------------------------------------
-- Extend
-------------------------------------------------------------------------------

---@param typeInfo Freemaker.ClassSystem.Type
---@param name string
---@param func function
local function UpdateMethods(typeInfo, name, func)
    if Utils.Table.ContainsKey(typeInfo.Members, name) then
        error("trying to extend already existing meta method: " .. name)
    end

    InstanceHandler.UpdateMetaMethod(typeInfo, name, func)
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param key any
---@param value any
local function UpdateMember(typeInfo, key, value)
    if Utils.Table.ContainsKey(typeInfo.Members, key) then
        error("trying to extend already existing member: " .. tostring(key))
    end

    InstanceHandler.UpdateMember(typeInfo, key, value)
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param name string
---@param value any
local function extendIsStaticMember(typeInfo, name, value)
    if Utils.Table.ContainsKey(typeInfo.Static, name) then
        error("trying to extend already existing static member: " .. name)
    end

    typeInfo.Static[name] = value
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param name string
---@param func function
local function extendIsNormalFunction(typeInfo, name, func)
    if Utils.Table.ContainsKey(Configs.AllMetaMethods, name) then
        UpdateMethods(typeInfo, name, func)
    end

    UpdateMember(typeInfo, name, func)
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param name string
---@param value any
local function extendIsNormalMember(typeInfo, name, value)
    if type(value) == 'function' then
        extendIsNormalFunction(typeInfo, name, value)
        return
    end

    UpdateMember(typeInfo, name, value)
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param key any
---@param value any
local function extendMember(typeInfo, key, value)
    if type(key) == 'string' then
        local splittedKey = Utils.String.Split(key, '__')
        if Utils.Table.Contains(splittedKey, 'Static') then
            extendIsStaticMember(typeInfo, key, value)
            return
        end

        extendIsNormalMember(typeInfo, key, value)
        return
    end

    if not Utils.Table.ContainsKey(typeInfo.Members, key) then
        typeInfo.Members[key] = value
    end
end

---@param data table
---@param typeInfo Freemaker.ClassSystem.Type
function MembersHandler.Extend(typeInfo, data)
    for key, value in pairs(data) do
        extendMember(typeInfo, key, value)
    end

    MembersHandler.UpdateState(typeInfo)
end

-------------------------------------------------------------------------------
-- Check
-------------------------------------------------------------------------------

---@param typeInfo Freemaker.ClassSystem.Type
function MembersHandler.Check(typeInfo)
    if Utils.Table.Contains(typeInfo.Members, Configs.AbstractPlaceholder) and not typeInfo.IsAbstract then
        error(typeInfo.Name .. " has abstract member/s but is not marked as abstract")
    end

    if not typeInfo.Base then
        return
    end

    for key, value in pairs(typeInfo.Base.Members) do
        if value == Configs.AbstractPlaceholder then
            if not Utils.Table.ContainsKey(typeInfo.Members, key) then
                error(
                    typeInfo.Name
                    .. " does not implement inherited abstract member: "
                    .. typeInfo.Base.Name .. "." .. tostring(key)
                )
            end
        end
    end
end

return MembersHandler
