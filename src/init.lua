local Config = require("src.Config")
local Utils = require("src.Utils")

local ObjectType = require("src.Object")
local TypeHandler = require("src.Type")
local MembersHandler = require("src.Members")
local InstanceHandler = require("src.Instance")
local ConstructionHandler = require("src.Construction")

---@class Freemaker.ClassSystem
local ClassSystem = {}

ClassSystem.GetNormal = Config.GetNormal
ClassSystem.SetNormal = Config.SetNormal
ClassSystem.Deconstructed = Config.Deconstructed
ClassSystem.Placeholder = Config.Placeholder

---@generic TClass : object
---@param data TClass
---@param name string
---@param baseClass object?
---@return TClass
function ClassSystem.Create(data, name, baseClass)
    local baseClassType
    if not baseClass then
        baseClassType = ObjectType
    else
        baseClassType = ClassSystem.Typeof(baseClass)
    end
    if not baseClassType then
        error("provided base class is not a class")
    end

    local typeInfo = TypeHandler.Create(name, baseClassType)

    MembersHandler.Initialize(typeInfo)
    MembersHandler.Sort(data, typeInfo)

    Utils.Table.Clear(data)

    InstanceHandler.InitializeType(typeInfo)
    ConstructionHandler.Template(data, typeInfo)

    return data
end

---@generic TClass : object
---@param class TClass
---@param extensions TClass
---@return TClass
function ClassSystem.Extend(class, extensions)
    if not ClassSystem.IsClass(class) then
        error("provided class is not an class")
    end

    ---@type Freemaker.ClassSystem.Metatable
    local metatable = getmetatable(class)
    local typeInfo = metatable.Type

    MembersHandler.Extend(typeInfo, extensions)

    return class
end

---@param obj object
function ClassSystem.Deconstruct(obj)
    ---@type Freemaker.ClassSystem.Metatable
    local metatable = getmetatable(obj)
    local instance = metatable.Instance
    local typeInfo = metatable.Type

    ConstructionHandler.Deconstruct(obj, metatable, instance, typeInfo)
end

ClassSystem.Typeof = Utils.Class.Typeof
ClassSystem.Nameof = Utils.Class.Nameof
ClassSystem.GetInstanceData = Utils.Class.GetInstanceData
ClassSystem.IsClass = Utils.Class.IsClass
ClassSystem.HasBase = Utils.Class.HasBase

return ClassSystem
