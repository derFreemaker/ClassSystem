local Utils = require("tools.Freemaker.bin.utils")

local Config = require("src.Config")

local InstanceHandler = require("src.Instance")

---@class Freemaker.ClassSystem.MembersHandler
local MembersHandler = {}

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
    return rawget(typeInfo.Static, key)
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
        ---@cast key string

        local splittedKey = Utils.String.Split(key:lower(), "__")
        if Utils.Table.Contains(splittedKey, "static") then
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
        ---@cast key string

        local splittedKey = Utils.String.Split(key:lower(), "__")
        if Utils.Table.Contains(splittedKey, "static") then
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
            ---@cast key string
            local splittedKey = Utils.String.Split(key:lower(), "__")
            if Utils.Table.Contains(splittedKey, "static") then
                return MembersHandler.GetStatic(typeInfo, key)
            elseif Utils.Table.Contains(splittedKey, "raw") then
                return rawget(obj, key)
            end
        end

        if typeInfo.HasIndex and instance.CustomIndexing then
            return typeInfo.MetaMethods.__index(obj, key)
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
            ---@cast key string
            local splittedKey = Utils.String.Split(key:lower(), "__")
            if Utils.Table.Contains(splittedKey, "static") then
                return MembersHandler.SetStatic(typeInfo, key, value)
            elseif Utils.Table.Contains(splittedKey, "raw") then
                rawset(obj, key, value)
            end
        end

        if typeInfo.HasNewIndex and instance.CustomIndexing then
            return typeInfo.MetaMethods.__newindex(obj, key, value)
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
    if Utils.Table.ContainsKey(Config.AllMetaMethods, name) then
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
    if Utils.Table.ContainsKey(Config.AllMetaMethods, name) then
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

---@private
---@param baseInfo Freemaker.ClassSystem.Type
---@param member string
---@return boolean
function MembersHandler.CheckForMetaMethod(baseInfo, member)
    if Utils.Table.ContainsKey(baseInfo.MetaMethods, member) then
        return true
    end

    if baseInfo.Base then
        return MembersHandler.CheckForMetaMethod(baseInfo.Base, member)
    end

    return false
end

---@private
---@param typeInfo Freemaker.ClassSystem.Type
---@param member string
---@return boolean
function MembersHandler.CheckForMember(typeInfo, member)
    if Utils.Table.ContainsKey(typeInfo.Members, member)
        and typeInfo.Members[member] ~= Config.AbstractPlaceholder
        and typeInfo.Members[member] ~= Config.InterfacePlaceholder then
        return true
    end

    if typeInfo.Base then
        return MembersHandler.CheckForMember(typeInfo.Base, member)
    end

    return false
end

---@private
---@param typeInfo Freemaker.ClassSystem.Type
---@param typeInfoToCheck Freemaker.ClassSystem.Type
function MembersHandler.CheckAbstract(typeInfo, typeInfoToCheck)
    for key, value in pairs(typeInfo.MetaMethods) do
        if value == Config.AbstractPlaceholder then
            if not MembersHandler.CheckForMetaMethod(typeInfoToCheck, key) then
                error(
                    typeInfoToCheck.Name
                    .. " does not implement inherited abstract meta method: "
                    .. typeInfo.Name .. "." .. tostring(key)
                )
            end
        end
    end

    for key, value in pairs(typeInfo.Members) do
        if value == Config.AbstractPlaceholder then
            if not MembersHandler.CheckForMember(typeInfoToCheck, key) then
                error(
                    typeInfoToCheck.Name
                    .. " does not implement inherited abstract member: "
                    .. typeInfo.Name .. "." .. tostring(key)
                )
            end
        end
    end

    if typeInfo.Base and typeInfo.Base.Options.IsAbstract then
        MembersHandler.CheckAbstract(typeInfo.Base, typeInfoToCheck)
    end
end

---@private
---@param typeInfo Freemaker.ClassSystem.Type
---@param typeInfoToCheck Freemaker.ClassSystem.Type
function MembersHandler.CheckInterfaces(typeInfo, typeInfoToCheck)
    for _, interface in pairs(typeInfo.Interfaces) do
        for key, value in pairs(interface.MetaMethods) do
            if value == Config.InterfacePlaceholder then
                if not MembersHandler.CheckForMetaMethod(typeInfoToCheck, key) then
                    error(
                        typeInfoToCheck.Name
                        .. " does not implement inherited interface meta method: "
                        .. interface.Name .. "." .. tostring(key)
                    )
                end
            end
        end

        for key, value in pairs(interface.Members) do
            if value == Config.InterfacePlaceholder then
                if not MembersHandler.CheckForMember(typeInfoToCheck, key) then
                    error(
                        typeInfoToCheck.Name
                        .. " does not implement inherited interface member: "
                        .. interface.Name .. "." .. tostring(key)
                    )
                end
            end
        end
    end

    if typeInfo.Base then
        MembersHandler.CheckInterfaces(typeInfo.Base, typeInfoToCheck)
    end
end

---@param typeInfo Freemaker.ClassSystem.Type
function MembersHandler.Check(typeInfo)
    if not typeInfo.Options.IsAbstract then
        if Utils.Table.Contains(typeInfo.MetaMethods, Config.AbstractPlaceholder) then
            error(typeInfo.Name .. " has abstract meta method/s but is not marked as abstract")
        end

        if Utils.Table.Contains(typeInfo.Members, Config.AbstractPlaceholder) then
            error(typeInfo.Name .. " has abstract member/s but is not marked as abstract")
        end
    end

    if not typeInfo.Options.IsInterface then
        if Utils.Table.Contains(typeInfo.Members, Config.InterfacePlaceholder) then
            error(typeInfo.Name .. " has interface meta methods/s but is not marked as interface")
        end

        if Utils.Table.Contains(typeInfo.Members, Config.InterfacePlaceholder) then
            error(typeInfo.Name .. " has interface member/s but is not marked as interface")
        end
    end

    if not typeInfo.Options.IsAbstract and not typeInfo.Options.IsInterface then
        MembersHandler.CheckInterfaces(typeInfo, typeInfo)

        if typeInfo.Base and typeInfo.Base.Options.IsAbstract then
            MembersHandler.CheckAbstract(typeInfo.Base, typeInfo)
        end
    end
end

return MembersHandler
