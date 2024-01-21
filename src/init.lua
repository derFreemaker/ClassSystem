-- required at top to be at the top of the bundled file
local Configs = require("src.Config")

-- to package meta in the bundled file
_ = require("src.Meta")

local Utils = require("tools.Freemaker.bin.utils")

local ClassUtils = require("src.ClassUtils")

local ObjectType = require("src.Object")
local TypeHandler = require("src.Type")
local MembersHandler = require("src.Members")
local InstanceHandler = require("src.Instance")
local ConstructionHandler = require("src.Construction")

---@class Freemaker.ClassSystem
local ClassSystem = {}

ClassSystem.GetNormal = Configs.GetNormal
ClassSystem.SetNormal = Configs.SetNormal
ClassSystem.Deconstructed = Configs.Deconstructing
ClassSystem.Placeholder = Configs.Placeholder
ClassSystem.IsAbstract = Configs.AbstractPlaceholder

---@param options Freemaker.ClassSystem.Create.Options
---@return Freemaker.ClassSystem.Type baseClass
local function processOptions(options)
    options.IsAbstract = options.IsAbstract or false

    if options.BaseClass and not ClassSystem.IsClass(options.BaseClass) then
        error("the provided base class is not a class", 2)
    end
    local baseClass = ClassSystem.Typeof(options.BaseClass) or ObjectType
    options.BaseClass = nil

    return baseClass
end

---@generic TClass : object
---@param data TClass
---@param name string
---@param options Freemaker.ClassSystem.Create.Options?
---@return TClass
function ClassSystem.Create(data, name, options)
    options = options or {}
    local baseClass = processOptions(options)

    local typeInfo = TypeHandler.Create(name, baseClass, options)

    MembersHandler.Initialize(typeInfo)
    MembersHandler.Sort(data, typeInfo)
    MembersHandler.Check(typeInfo)

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
    local typeInfo = metatable.Type

    ConstructionHandler.Deconstruct(obj, metatable, typeInfo)
end

ClassSystem.Typeof = ClassUtils.Class.Typeof
ClassSystem.Nameof = ClassUtils.Class.Nameof
ClassSystem.GetInstanceData = ClassUtils.Class.GetInstanceData
ClassSystem.IsClass = ClassUtils.Class.IsClass
ClassSystem.HasBase = ClassUtils.Class.HasBase

return ClassSystem
