-- required at top to be at the top of the bundled file
local Configs = require("src.Config")

-- to package meta in the bundled file
require("src.Meta")

local Utils = require("tools.Freemaker.bin.utils")

local Class = require("src.Class")
local ObjectType = require("src.Object")
local TypeHandler = require("src.Type")
local MembersHandler = require("src.Members")
local ConstructionHandler = require("src.Construction")

---@class Freemaker.ClassSystem
local ClassSystem = {}

ClassSystem.GetNormal = Configs.GetNormal
ClassSystem.SetNormal = Configs.SetNormal
ClassSystem.Deconstructed = Configs.Deconstructing
ClassSystem.IsAbstract = Configs.AbstractPlaceholder
ClassSystem.IsInterface = Configs.InterfacePlaceholder --//TODO: how to find better name

ClassSystem.ObjectType = ObjectType

ClassSystem.Typeof = Class.Typeof
ClassSystem.Nameof = Class.Nameof
ClassSystem.GetInstanceData = Class.GetInstanceData
ClassSystem.IsClass = Class.IsClass
ClassSystem.HasBase = Class.HasBase

---@param options Freemaker.ClassSystem.Create.Options
---@return Freemaker.ClassSystem.Type | nil base, table<Freemaker.ClassSystem.Type> interfaces
local function processOptions(options)
    options.IsAbstract = options.IsAbstract or false
    options.IsInterface = options.IsInterface or false

    if options.IsAbstract and options.IsInterface then
        error("cannot mark class as interface and abstract class")
    end

    if options.Inherit then
        if ClassSystem.IsClass(options.Inherit) then
            options.Inherit = { options.Inherit }
        end
    else
        -- could also return here
        options.Inherit = {}
    end

    ---@type Freemaker.ClassSystem.Type, table<Freemaker.ClassSystem.Type>
    local base, interfaces = nil, {}
    for i, parent in ipairs(options.Inherit) do
        local parentType = ClassSystem.Typeof(parent)
        ---@cast parentType Freemaker.ClassSystem.Type

        if options.IsAbstract and not parentType.Options.IsAbstract then
            error("cannot inherit from not abstract class: ".. tostring(parent) .." in abstract class: " .. options.Name)
        end

        if parentType.Options.IsInterface then
            interfaces[i] = ClassSystem.Typeof(parent)
        else
            if base ~= nil then
                error("cannot inherit from more than one (abstract) class: " .. tostring(parent) .. " in class: " .. options.Name)
            end

            base = parentType
        end
    end

    if not options.IsAbstract and not options.IsInterface and not base then
        base = ObjectType
    end

    return base, interfaces
end

---@generic TClass : object
---@param data TClass
---@param options Freemaker.ClassSystem.Create.Options
---@return TClass
function ClassSystem.Create(data, options)
    options = options or {}
    local base, interfaces = processOptions(options)

    local typeInfo = TypeHandler.Create(base, interfaces, options)

    MembersHandler.Sort(data, typeInfo)
    MembersHandler.Check(typeInfo)

    Utils.Table.Clear(data)

    ConstructionHandler.CreateTemplate(data, typeInfo)

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

return ClassSystem
