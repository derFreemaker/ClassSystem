local Utils = require("tools.Freemaker.bin.utils")

local Config = require("src.Config")

local MembersHandler = require("src.Members")

---@class Freemaker.ClassSystem.MetatableHandler
local MetatableHandler = {}

---@param typeInfo Freemaker.ClassSystem.Type
---@return Freemaker.ClassSystem.BlueprintMetatable metatable
function MetatableHandler.CreateTemplateMetatable(typeInfo)
    ---@type Freemaker.ClassSystem.BlueprintMetatable
    local metatable = { Type = typeInfo }

    metatable.__index = MembersHandler.TemplateIndex(typeInfo)
    metatable.__newindex = MembersHandler.TemplateNewIndex(typeInfo)

    for key in pairs(Config.BlockMetaMethodsOnBlueprint) do
        local function blockMetaMethod()
            error("cannot use meta method: " .. key .. " on a template from a class")
        end
        ---@diagnostic disable-next-line: assign-type-mismatch
        metatable[key] = blockMetaMethod
    end

    metatable.__tostring = function()
        return typeInfo.Name .. ".__Blueprint__"
    end

    return metatable
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param instance Freemaker.ClassSystem.Instance
---@param metatable Freemaker.ClassSystem.Metatable
function MetatableHandler.Create(typeInfo, instance, metatable)
    metatable.Type = typeInfo

    metatable.__index = MembersHandler.InstanceIndex(instance, typeInfo)
    metatable.__newindex = MembersHandler.InstanceNewIndex(instance, typeInfo)

    for key, _ in pairs(Config.BlockMetaMethodsOnInstance) do
        if not Utils.Table.ContainsKey(typeInfo.MetaMethods, key) then
            local function blockMetaMethod()
                error("cannot use meta method: " .. key .. " on class: " .. typeInfo.Name)
            end
            metatable[key] = blockMetaMethod
        end
    end
end

return MetatableHandler
