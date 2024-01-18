local Utils = require("tools.Freemaker.bin.utils")

---@class Freemaker.ClassSystem.InstanceHandler
local InstanceHandler = {}

---@param instance Freemaker.ClassSystem.Instance
function InstanceHandler.Initialize(instance)
    -- instance.Members = {}
    instance.CustomIndexing = true
end

---@param typeInfo Freemaker.ClassSystem.Type
function InstanceHandler.InitializeType(typeInfo)
    typeInfo.Instances = setmetatable({}, { __mode = "k" })
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param instance object
function InstanceHandler.Add(typeInfo, instance)
    typeInfo.Instances[instance] = true

    if typeInfo.Base then
        InstanceHandler.Add(typeInfo.Base, instance)
    end
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param instance object
function InstanceHandler.Remove(typeInfo, instance)
    typeInfo.Instances[instance] = nil

    if typeInfo.Base then
        InstanceHandler.Remove(typeInfo.Base, instance)
    end
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param name string
---@param func function
function InstanceHandler.UpdateMetaMethod(typeInfo, name, func)
    typeInfo.MetaMethods[name] = func

    for instance in pairs(typeInfo.Instances) do
        local instanceMetatable = getmetatable(instance)

        if not Utils.Table.ContainsKey(instanceMetatable, name) then
            instanceMetatable[name] = func
        end
    end
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param key any
---@param value any
function InstanceHandler.UpdateMember(typeInfo, key, value)
    typeInfo.Members[key] = value

    for instance in pairs(typeInfo.Instances) do
        if not Utils.Table.ContainsKey(instance, key) then
            rawset(instance, key, value)
        end
    end
end

return InstanceHandler
