local Utils = require("tools.Freemaker.bin.utils")

local Config = require("src.Config")

local InstanceHandler = require("src.Instance")
local MetatableHandler = require("src.Metatable")

---@class Freemaker.ClassSystem.ConstructionHandler
local ConstructionHandler = {}

---@param obj object
---@return Freemaker.ClassSystem.Instance instance
local function construct(obj, ...)
    ---@type Freemaker.ClassSystem.Metatable
    local metatable = getmetatable(obj)
    local typeInfo = metatable.Type

    if typeInfo.IsAbstract then
        error("cannot construct abstract class: " .. typeInfo.Name)
    end

    local classInstance, classMetatable = {}, {}
    ---@cast classInstance Freemaker.ClassSystem.Instance
    ---@cast classMetatable Freemaker.ClassSystem.Metatable
    classMetatable.Instance = classInstance
    local instance = setmetatable({}, classMetatable)

    InstanceHandler.Initialize(classInstance)
    MetatableHandler.Create(typeInfo, classInstance, classMetatable)
    ConstructionHandler.Construct(typeInfo, instance, classInstance, classMetatable, ...)

    InstanceHandler.Add(typeInfo, classInstance)

    return instance
end

---@param data table
---@param typeInfo Freemaker.ClassSystem.Type
function ConstructionHandler.Template(data, typeInfo)
    local metatable = MetatableHandler.Template(typeInfo)
    metatable.__call = construct

    setmetatable(data, metatable)
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param class table
local function invokeDeconstructor(typeInfo, class)
    if typeInfo.HasClose then
        typeInfo.MetaMethods.__close(class, Config.Deconstructing)
    end
    if typeInfo.HasDeconstructor then
        typeInfo.MetaMethods.__gc(class)
        invokeDeconstructor(typeInfo.Base, class)
    end
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param obj object
---@param instance Freemaker.ClassSystem.Instance
---@param metatable Freemaker.ClassSystem.Metatable
---@param ... any
function ConstructionHandler.Construct(typeInfo, obj, instance, metatable, ...)
    ---@type function
    local super = nil

    local function constructMembers()
        for key, value in pairs(typeInfo.MetaMethods) do
            if not Utils.Table.ContainsKey(Config.IndirectMetaMethods, key) then
                metatable[key] = value
            end
        end

        for key, value in pairs(typeInfo.Members) do
            rawset(obj, key, Utils.Value.Copy(value))
        end

        metatable.__gc = function(deClass)
            invokeDeconstructor(typeInfo, deClass)
        end

        setmetatable(obj, metatable)
    end

    if typeInfo.Base then
        if typeInfo.Base.HasConstructor then
            function super(...)
                ConstructionHandler.Construct(typeInfo.Base, obj, instance, metatable, ...)
                constructMembers()
                return obj
            end
        else
            ConstructionHandler.Construct(typeInfo.Base, obj, instance, metatable)
            constructMembers()
        end
    else
        constructMembers()
    end

    if typeInfo.HasConstructor then
        if super then
            typeInfo.MetaMethods.__init(obj, super, ...)
        else
            typeInfo.MetaMethods.__init(obj, ...)
        end
    end
end

---@param obj object
---@param metatable Freemaker.ClassSystem.Metatable
---@param instance Freemaker.ClassSystem.Instance
---@param typeInfo Freemaker.ClassSystem.Type
function ConstructionHandler.Deconstruct(obj, metatable, instance, typeInfo)
    InstanceHandler.Remove(typeInfo, instance)
    invokeDeconstructor(typeInfo, instance)

    Utils.Table.Clear(instance)
    Utils.Table.Clear(metatable)

    local function blockedNewIndex()
        error("cannot assign values to deconstruct class: " .. typeInfo.Name, 2)
    end
    metatable.__newindex = blockedNewIndex

    local function blockedIndex()
        error("cannot get values from deconstruct class: " .. typeInfo.Name, 2)
    end
    metatable.__index = blockedIndex

    setmetatable(obj, metatable)
end

return ConstructionHandler
