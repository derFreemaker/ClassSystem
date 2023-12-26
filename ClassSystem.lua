-- ############ Meta ############ --

---@class Freemaker.ClassSystem.ObjectMetaMethods
---@field protected __init (fun(self: object, ...))? self(...) before construction
---@field protected __call (fun(self: object, ...) : ...)? self(...) after construction
---@field protected __close (fun(self: object, errObj: any) : any)? invoked when the object gets out of scope
---@field protected __gc fun(self: object)? Freemaker.ClassSystem.Deconstruct(self) or garbageCollection
---@field protected __add (fun(self: object, other: any) : any)? (self) + (value)
---@field protected __sub (fun(self: object, other: any) : any)? (self) - (value)
---@field protected __mul (fun(self: object, other: any) : any)? (self) * (value)
---@field protected __div (fun(self: object, other: any) : any)? (self) / (value)
---@field protected __mod (fun(self: object, other: any) : any)? (self) % (value)
---@field protected __pow (fun(self: object, other: any) : any)? (self) ^ (value)
---@field protected __idiv (fun(self: object, other: any) : any)? (self) // (value)
---@field protected __band (fun(self: object, other: any) : any)? (self) & (value)
---@field protected __bor (fun(self: object, other: any) : any)? (self) | (value)
---@field protected __bxor (fun(self: object, other: any) : any)? (self) ~ (value)
---@field protected __shl (fun(self: object, other: any) : any)? (self) << (value)
---@field protected __shr (fun(self: object, other: any) : any)? (self) >> (value)
---@field protected __concat (fun(self: object, other: any) : any)? (self) .. (value)
---@field protected __eq (fun(self: object, other: any) : any)? (self) == (value)
---@field protected __lt (fun(t1: any, t2: any) : any)? (self) < (value)
---@field protected __le (fun(t1: any, t2: any) : any)? (self) <= (value)
---@field protected __unm (fun(self: object) : any)? -(self)
---@field protected __bnot (fun(self: object) : any)?  ~(self)
---@field protected __len (fun(self: object) : any)? #(self)
---@field protected __pairs (fun(t: table) : ((fun(t: table, key: any) : key: any, value: any), t: table, startKey: any))? pairs(self)
---@field protected __ipairs (fun(t: table) : ((fun(t: table, key: number) : key: number, value: any), t: table, startKey: number))? ipairs(self)
---@field protected __tostring (fun(t):string)? tostring(self)
---@field protected __index (fun(class, key) : any)? xxx = self.xxx | self[xxx]
---@field protected __newindex fun(class, key, value)? self.xxx = xxx | self[xxx] = xxx

---@class Freemaker.ClassSystem.MetaMethods
---@field __init (fun(self: object, ...))? self(...) before construction
---@field __gc fun(self: object)? Class.Deconstruct(self) or garbageCollection
---@field __close (fun(self: object, errObj: any) : any)? invoked when the object gets out of scope
---@field __call (fun(self: object, ...) : ...)? self(...) after construction
---@field __index (fun(class: object, key: any) : any)? xxx = self.xxx | self[xxx]
---@field __newindex fun(class: object, key: any, value: any)? self.xxx | self[xxx] = xxx
---@field __tostring (fun(t):string)? tostring(self)
---@field __add (fun(left: any, right: any) : any)? (left) + (right)
---@field __sub (fun(left: any, right: any) : any)? (left) - (right)
---@field __mul (fun(left: any, right: any) : any)? (left) * (right)
---@field __div (fun(left: any, right: any) : any)? (left) / (right)
---@field __mod (fun(left: any, right: any) : any)? (left) % (right)
---@field __pow (fun(left: any, right: any) : any)? (left) ^ (right)
---@field __idiv (fun(left: any, right: any) : any)? (left) // (right)
---@field __band (fun(left: any, right: any) : any)? (left) & (right)
---@field __bor (fun(left: any, right: any) : any)? (left) | (right)
---@field __bxor (fun(left: any, right: any) : any)? (left) ~ (right)
---@field __shl (fun(left: any, right: any) : any)? (left) << (right)
---@field __shr (fun(left: any, right: any) : any)? (left) >> (right)
---@field __concat (fun(left: any, right: any) : any)? (left) .. (right)
---@field __eq (fun(left: any, right: any) : any)? (left) == (right)
---@field __lt (fun(left: any, right: any) : any)? (left) < (right)
---@field __le (fun(left: any, right: any) : any)? (left) <= (right)
---@field __unm (fun(self: object) : any)? -(self)
---@field __bnot (fun(self: object) : any)?  ~(self)
---@field __len (fun(self: object) : any)? #(self)
---@field __pairs (fun(self: object) : ((fun(t: table, key: any) : key: any, value: any), t: table, startKey: any))? pairs(self)
---@field __ipairs (fun(self: object) : ((fun(t: table, key: number) : key: number, value: any), t: table, startKey: number))? ipairs(self)

---@class Freemaker.ClassSystem.Type
---@field Name string
---@field Base Freemaker.ClassSystem.Type
---
---@field Static table<string, any>
---
---@field MetaMethods Freemaker.ClassSystem.MetaMethods
---@field Members table<string, any>
---
---
---@field HasConstructor boolean
---@field HasDeconstructor boolean
---@field HasClose boolean
---
---@field IndexingDisabled boolean
---@field HasIndex boolean
---@field HasNewIndex boolean
---
---@field Template table
---@field Instances table<Freemaker.ClassSystem.Instance, boolean>

---@class Freemaker.ClassSystem.Metatable : Freemaker.ClassSystem.MetaMethods
---@field Type Freemaker.ClassSystem.Type

---@class Freemaker.ClassSystem.Template

---@class Freemaker.ClassSystem.Instance : table

---@class Out<T> : { Value: T }

-- ############ Meta ############ --

-- ############ Config ############ --

---@class Freemaker.ClassSystem.Configs
local Config = {}

Config.AllMetaMethods = {
    --- Constructor
    __init = true,
    --- Garbage Collection
    __gc = true,
    --- Out of Scope
    __close = true,

    --- Special
    __call = true,
    __newindex = true,
    __index = true,
    __pairs = true,
    __ipairs = true,
    __tostring = true,

    -- Operators
    __add = true,
    __sub = true,
    __mul = true,
    __div = true,
    __mod = true,
    __pow = true,
    __unm = true,
    __idiv = true,
    __band = true,
    __bor = true,
    __bxor = true,
    __bnot = true,
    __shl = true,
    __shr = true,
    __concat = true,
    __len = true,
    __eq = true,
    __lt = true,
    __le = true
}

Config.OverrideMetaMethods = {
    __pairs = true,
    __ipairs = true
}

Config.IndirectMetaMethods = {
    __gc = true,
    __index = true,
    __newindex = true
}

-- Indicates that value in newindex should be set like table[index] = value. Needs to be returned by the __newindex meta method.
Config.SetNormal = {}

-- Indicates that the value should be retrieved with rawget. Needs to be returned by the __index meta method.
Config.GetNormal = {}

-- ############ Config ############ --

-- ############ Table ############ --

---@class Freemaker.ClassSystem.TableUtils
local Table = {}

---@param obj table?
---@param seen table[]
---@return table?
local function copyTable(obj, copy, seen)
    if obj == nil then return nil end
    if seen[obj] then return seen[obj] end

    seen[obj] = copy
    setmetatable(copy, copyTable(getmetatable(obj), {}, seen))

    for key, value in next, obj, nil do
        key = (type(key) == "table") and copyTable(key, {}, seen) or key
        value = (type(value) == "table") and copyTable(value, {}, seen) or value
        rawset(copy, key, value)
    end

    return copy
end

---@generic TTable
---@param t TTable
---@return TTable table
function Table.Copy(t)
    return copyTable(t, {}, {})
end

---@param t table
---@param ignoreProperties string[]?
function Table.Clear(t, ignoreProperties)
    if not ignoreProperties then
        ignoreProperties = {}
    end
    for key, _ in next, t, nil do
        if not Table.Contains(ignoreProperties, key) then
            t[key] = nil
        end
    end
    setmetatable(t, nil)
end

---@param t table
---@param value any
---@return boolean
function Table.Contains(t, value)
    for _, tValue in pairs(t) do
        if value == tValue then
            return true
        end
    end
    return false
end

---@param t table
---@param key any
---@return boolean
function Table.ContainsKey(t, key)
    if t[key] ~= nil then
        return true
    end
    return false
end

-- ############ Table ############ --

-- ############ String ############ --

---@class Freemaker.ClassSystem.StringUtils
local String = {}

---@param str string
---@param pattern string
---@return string?, integer
local function findNext(str, pattern)
    local found = str:find(pattern, 0, true)
    if found == nil then
        return nil, 0
    end
    return str:sub(0, found - 1), found - 1
end

---@param str string?
---@param sep string?
---@return string[]
function String.Split(str, sep)
    if str == nil then
        return {}
    end

    local strLen = str:len()
    local sepLen

    if sep == nil then
        sep = "%s"
        sepLen = 2
    else
        sepLen = sep:len()
    end

    local tbl = {}
    local i = 0
    while true do
        i = i + 1
        local foundStr, foundPos = findNext(str, sep)

        if foundStr == nil then
            tbl[i] = str
            return tbl
        end

        tbl[i] = foundStr
        str = str:sub(foundPos + sepLen + 1, strLen)
    end
end

-- ############ String ############ --

-- ############ Value ############ --

---@class Freemaker.ClassSystem.ValueUtils
local Value = {}

---@generic T
---@param value T
---@return T
function Value.Copy(value)
    local typeStr = type(value)

    if typeStr == "table" then
        return Table.Copy(value)
    end

    return value
end

-- ############ Value ############ --

-- ############ InstanceHandler ############ --

---@class Freemaker.ClassSystem.InstanceHandler
local InstanceHandler = {}

---@param typeInfo Freemaker.ClassSystem.Type
function InstanceHandler.Initialize(typeInfo)
    typeInfo.Instances = setmetatable({}, { __mode = "k" })
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param instance Freemaker.ClassSystem.Instance
function InstanceHandler.Add(typeInfo, instance)
    if not typeInfo then
        return
    end

    typeInfo.Instances[instance] = true
    InstanceHandler.Add(typeInfo.Base, instance)
end

function InstanceHandler.Remove(typeInfo, instance)
    if not typeInfo then
        return
    end

    typeInfo.Instances[instance] = nil
    InstanceHandler.Remove(typeInfo.Base, instance)
end

function InstanceHandler.UpdateMetaMethod(typeInfo, name, func)
    typeInfo.MetaMethods[name] = func

    for instance in pairs(typeInfo.Instances) do
        local instanceMetatable = getmetatable(instance)

        if not Table.ContainsKey(instanceMetatable, name) then
            rawset(instanceMetatable, name, func)
        end
    end
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param key any
---@param value any
function InstanceHandler.UpdateMember(typeInfo, key, value)
    typeInfo.Members[key] = value

    for instance in pairs(typeInfo.Instances) do
        if not Table.ContainsKey(instance, key) then
            rawset(instance, key, value)
        end
    end
end

-- ############ InstanceHandler ############ --

-- ############ Object ############ --

---@class object : Freemaker.ClassSystem.ObjectMetaMethods, function
local Object = {}

---@protected
---@return string typeName
function Object:__tostring()
    return typeof(self).Name
end

---@protected
---@return string
function Object.__concat(left, right)
    return tostring(left) .. tostring(right)
end

---@class object.Modify
---@field DisableCustomIndexing boolean?

---@protected
---@param modify object.Modify
function Object:Raw__ModifyBehavior(modify)
    local metatable = getmetatable(self)

    if modify.DisableCustomIndexing ~= nil then
        metatable.Type.IndexingDisabled = modify.DisableCustomIndexing
    end
end

----------------------------------------
-- Type Info
----------------------------------------

local ObjectTypeInfo = {}
---@cast ObjectTypeInfo Freemaker.ClassSystem.Type

ObjectTypeInfo.Name = 'object'

ObjectTypeInfo.Static = {}
ObjectTypeInfo.MetaMethods = {}
ObjectTypeInfo.Members = {}

for key, value in pairs(Object) do
    if Config.AllMetaMethods[key] then
        ObjectTypeInfo.MetaMethods[key] = value
    else
        if type(key) == 'string' then
            local splittedKey = String.Split(key, '__')
            if Table.Contains(splittedKey, 'Static') then
                ObjectTypeInfo.Static[key] = value
            else
                ObjectTypeInfo.Members[key] = value
            end
        else
            ObjectTypeInfo.Members[key] = value
        end
    end
end

ObjectTypeInfo.HasConstructor = false
ObjectTypeInfo.HasDeconstructor = false
ObjectTypeInfo.HasIndex = false
ObjectTypeInfo.HasNewIndex = false

ObjectTypeInfo.Instances = setmetatable({}, { __mode = 'k' })

-- ############ Object ############ --

-- ############ MembersHandler ############ --

---@class Freemaker.ClassSystem..MembersHandler
local MembersHandler = {}

---@param typeInfo Freemaker.ClassSystem.Type
function MembersHandler.UpdateState(typeInfo)
    typeInfo.HasConstructor = typeInfo.MetaMethods.__init ~= nil
    typeInfo.HasDeconstructor = typeInfo.MetaMethods.__gc ~= nil
    typeInfo.HasClose = typeInfo.MetaMethods.__close ~= nil
    typeInfo.HasIndex = typeInfo.MetaMethods.__index ~= nil
    typeInfo.HasNewIndex = typeInfo.MetaMethods.__newindex ~= nil
end

-------------------------------------------------------------------------------
-- Sort
-------------------------------------------------------------------------------

---@param typeInfo Freemaker.ClassSystem.Type
---@param name string
---@param func function
local function isNormalFunction(typeInfo, name, func)
    if Table.ContainsKey(Config.AllMetaMethods, name) then
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
        local splittedKey = String.Split(key, '__')
        if Table.Contains(splittedKey, 'Static') then
            isStaticMember(typeInfo, key, value)
            return
        end

        isNormalMember(typeInfo, key, value)
        return
    end

    typeInfo.Members[key] = value
end

---@param data table
---@param typeInfo Freemaker.ClassSystem.Type
function MembersHandler.SortMembers(data, typeInfo)
    typeInfo.Static = {}
    typeInfo.MetaMethods = {}
    typeInfo.Members = {}

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
    if Table.ContainsKey(typeInfo.Members, name) then
        error("trying to extend already existing meta method: " .. name)
    end

    InstanceHandler.UpdateMetaMethod(typeInfo, name, func)
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param key any
---@param value any
local function UpdateMember(typeInfo, key, value)
    if Table.ContainsKey(typeInfo.Members, key) then
        error("trying to extend already existing member: " .. tostring(key))
    end

    InstanceHandler.UpdateMember(typeInfo, key, value)
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param name string
---@param value any
local function extendIsStaticMember(typeInfo, name, value)
    if Table.ContainsKey(typeInfo.Static, name) then
        error("trying to extend already existing static member: " .. name)
    end

    typeInfo.Static[name] = value
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param name string
---@param func function
local function extendIsNormalFunction(typeInfo, name, func)
    if Table.ContainsKey(Config.AllMetaMethods, name) then
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
        local splittedKey = String.Split(key, '__')
        if Table.Contains(splittedKey, 'Static') then
            extendIsStaticMember(typeInfo, key, value)
            return
        end

        extendIsNormalMember(typeInfo, key, value)
        return
    end

    if not Table.ContainsKey(typeInfo.Members, key) then
        typeInfo.Members[key] = value
    end
end

---@param data table
---@param typeInfo Freemaker.ClassSystem.Type
function MembersHandler.ExtendMembers(data, typeInfo)
    for key, value in pairs(data) do
        extendMember(typeInfo, key, value)
    end

    MembersHandler.UpdateState(typeInfo)
end

-- ############ MembersHandler ############ --

-- ############ TypeHandler ############ --

---@class Freemaker.ClassSystem.TypeHandler
local TypeHandler = {}

---@param name string
---@param baseClass object?
---@return Freemaker.ClassSystem.Type
function TypeHandler.CreateType(name, baseClass)
    local typeInfo = { Name = name, IndexingDisabled = false }
    ---@cast typeInfo Freemaker.ClassSystem.Type

    if baseClass then
        typeInfo.Base = typeof(baseClass)
    else
        typeInfo.Base = ObjectTypeInfo
    end

    setmetatable(
        typeInfo,
        {
            __tostring = function(self)
                return self.Name
            end
        }
    )

    return typeInfo
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

    if typeInfo.Name == "object" then
        return false
    end

    return assignStatic(typeInfo.Base, key, value)
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param key string
---@param value any
function TypeHandler.SetStatic(typeInfo, key, value)
    if not assignStatic(typeInfo, key, value) then
        rawset(typeInfo.Static, key, value)
    end
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param key string
function TypeHandler.GetStatic(typeInfo, key)
    local value = rawget(typeInfo.Static, key)

    if value ~= nil then
        return value
    end

    if typeInfo.Name == "object" then
        return nil
    end

    return TypeHandler.GetStatic(typeInfo.Base, key)
end

-- ############ TypeHandler ############ --

-- ############ MetatableHandler ############ --

---@class Freemaker.ClassSystem.MetatableHandler
local MetatableHandler = {}

---@param typeInfo Freemaker.ClassSystem.Type
---@return Freemaker.ClassSystem.Metatable templateMetatable
function MetatableHandler.CreateTemplateMetatable(typeInfo)
    ---@type Freemaker.ClassSystem.Metatable
    local metatable = { Type = typeInfo }

    ---@param obj object
    ---@param key any
    ---@return any value
    local function index(obj, key)
        if type(key) ~= "string" then
            error("can only use static members in template")
            return {}
        end

        local splittedKey = String.Split(key, "__")
        if Table.Contains(splittedKey, "Static") then
            return TypeHandler.GetStatic(typeInfo, key)
        end

        error("can only use static members in template")
    end
    metatable.__index = index

    ---@param obj object
    ---@param key any
    ---@param value any
    local function newindex(obj, key, value)
        if type(key) ~= "string" then
            error("can only use static members in template")
            return
        end

        local splittedKey = String.Split(key, "__")
        if Table.Contains(splittedKey, "Static") then
            TypeHandler.SetStatic(typeInfo, key, value)
            return
        end

        error("can only use static members in template")
    end
    metatable.__newindex = newindex

    for key, _ in pairs(Config.OverrideMetaMethods) do
        local function blockMetaMethod()
            error("cannot use meta method: " .. key .. " on a template from a class")
        end
        ---@diagnostic disable-next-line: assign-type-mismatch
        metatable[key] = blockMetaMethod
    end

    metatable.__tostring = function()
        return typeInfo.Name .. "->Template"
    end

    return metatable
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param metatable Freemaker.ClassSystem.Metatable
function MetatableHandler.CreateMetatable(typeInfo, metatable)
    metatable.Type = typeInfo

    ---@param obj object
    ---@param key any
    ---@return any value
    local function index(obj, key)
        if type(key) == "string" then
            local splittedKey = String.Split(key, "__")
            if Table.Contains(splittedKey, "Static") then
                return TypeHandler.GetStatic(typeInfo, key)
            elseif Table.Contains(splittedKey, "Raw") then
                return rawget(obj, key)
            end
        end

        if typeInfo.HasIndex and not typeInfo.IndexingDisabled then
            local value = typeInfo.MetaMethods.__index(obj, key)
            if value ~= Config.GetNormal then
                return value
            end
        end

        return rawget(obj, key)
    end
    metatable.__index = index

    ---@param obj object
    ---@param key any
    ---@param value any
    local function newindex(obj, key, value)
        if type(key) == "string" then
            local splittedKey = String.Split(key, "__")
            if Table.Contains(splittedKey, "Static") then
                return TypeHandler.SetStatic(typeInfo, key, value)
            elseif Table.Contains(splittedKey, "Raw") then
                return rawset(obj, key, value)
            end
        end

        if typeInfo.HasNewIndex and not typeInfo.IndexingDisabled then
            if typeInfo.MetaMethods.__newindex(obj, key, value) ~= Config.SetNormal then
                return
            end
        end

        return rawset(obj, key, value)
    end
    metatable.__newindex = newindex

    for key, _ in pairs(Config.OverrideMetaMethods) do
        if not Table.ContainsKey(typeInfo.MetaMethods, key) then
            local function blockMetaMethod()
                error("cannot use meta method: " .. key .. " on class: " .. typeInfo.Name)
            end
            metatable[key] = blockMetaMethod
        end
    end
end

-- ############ MetatableHandler ############ --

-- ############ ConstructionHandler ############ --

---@class Freemaker.ClassSystem.ConstructionHandler
local ConstructionHandler = {}

---@param obj object
---@return Freemaker.ClassSystem.Instance instance
local function construct(obj, ...)
    ---@type Freemaker.ClassSystem.Metatable
    local metatable = getmetatable(obj)
    local typeInfo = metatable.Type

    local classInstance, classMetatable = {}, {}
    ---@cast classInstance Freemaker.ClassSystem.Instance
    ---@cast classMetatable Freemaker.ClassSystem.Metatable

    MetatableHandler.CreateMetatable(typeInfo, classMetatable)
    ConstructionHandler.ConstructClass(typeInfo, classInstance, classMetatable, ...)

    InstanceHandler.Add(typeInfo, classInstance)

    return classInstance
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param class table
local function invokeDeconstructor(typeInfo, class)
    if typeInfo.HasClose then
        typeInfo.MetaMethods.__close(class, "Class Deconstruct")
    end
    if typeInfo.HasDeconstructor then
        typeInfo.MetaMethods.__gc(class)
        invokeDeconstructor(typeInfo.Base, class)
    end
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param data table
function ConstructionHandler.ConstructTemplate(typeInfo, data)
    Table.Clear(data)
    InstanceHandler.Initialize(typeInfo)

    local metatable = MetatableHandler.CreateTemplateMetatable(typeInfo)
    metatable.__call = construct

    data = setmetatable(data, metatable)
    typeInfo.Template = data
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param class table
---@param classMetatable Freemaker.ClassSystem.Metatable
---@param ... any
function ConstructionHandler.ConstructClass(typeInfo, class, classMetatable, ...)
    ---@type function
    local super = nil

    local function constructMembers()
        for key, value in pairs(typeInfo.MetaMethods) do
            if not Table.ContainsKey(Config.IndirectMetaMethods, key) then
                rawset(classMetatable, key, value)
            end
        end

        for key, value in pairs(typeInfo.Members) do
            if type(value) == "table" then
                rawset(class, key, Table.Copy(value))
            else
                rawset(class, key, Value.Copy(value))
            end
        end

        classMetatable.__gc = function(deClass)
            invokeDeconstructor(typeof(deClass), deClass)
        end

        setmetatable(class, classMetatable)
    end

    if typeInfo.Base then
        if typeInfo.Base.HasConstructor then
            function super(...)
                ConstructionHandler.ConstructClass(typeInfo.Base, class, classMetatable, ...)
                constructMembers()
                return class
            end
        else
            ConstructionHandler.ConstructClass(typeInfo.Base, class, classMetatable)
            constructMembers()
        end
    else
        constructMembers()
    end

    if typeInfo.HasConstructor then
        if super then
            typeInfo.MetaMethods.__init(class, super, ...)
        else
            typeInfo.MetaMethods.__init(class, ...)
        end
    end
end

---@param typeInfo Freemaker.ClassSystem.Type
---@param class table
---@param metatable Freemaker.ClassSystem.Metatable
function ConstructionHandler.Deconstruct(typeInfo, class, metatable)
    InstanceHandler.Remove(typeInfo, class)
    invokeDeconstructor(typeInfo, class)

    Table.Clear(class)
    Table.Clear(metatable)

    local function blockedNewIndex()
        error("cannot assign values to deconstruct class: " .. typeInfo.Name, 2)
    end
    metatable.__newindex = blockedNewIndex

    local function blockedIndex()
        error("cannot get values from deconstruct class: " .. typeInfo.Name, 2)
    end
    metatable.__index = blockedIndex

    setmetatable(class, metatable)
end

-- ############ ConstructionHandler ############ --

-- ############ ClassSystem ############ --

---@class Freemaker.ClassSystem
local Class = {}

---@type any
Class.Placeholder = {}

Class.GetNormal = Config.GetNormal
Class.SetNormal = Config.SetNormal

---@generic TClass
---@param data TClass
---@param name string
---@param baseClass object?
---@return TClass
function Class.Create(data, name, baseClass)
    local typeInfo = TypeHandler.CreateType(name, baseClass)

    MembersHandler.SortMembers(data, typeInfo)

    ConstructionHandler.ConstructTemplate(typeInfo, data)
    return data
end

---@generic TClass : object
---@param class TClass
---@param extensions TClass
---@return TClass
function Class.Extend(class, extensions)
    ---@type Out<Freemaker.ClassSystem.Metatable>
    local metatable = {}
    if not Class.IsClass(class, metatable) then
        error("provided class is not an class: " .. tostring(class))
        return class
    else
        metatable = metatable.Value
    end
    local typeInfo = metatable.Type

    MembersHandler.ExtendMembers(extensions, typeInfo)

    return typeInfo.Template
end

---@generic TClass
---@param class TClass
function Class.Deconstruct(class)
    ---@type Freemaker.ClassSystem.Metatable
    local metatable = getmetatable(class)
    local typeInfo = metatable.Type

    ConstructionHandler.Deconstruct(typeInfo, class, metatable)
end

---@param baseClassName string
---@param type Freemaker.ClassSystem.Type
---@return boolean hasBaseClass
function Class.HasTypeBaseClass(baseClassName, type)
    local typeName = type.Name
    if typeName == baseClassName then
        return true
    end

    if typeName == "object" then
        return false
    end

    return Class.HasTypeBaseClass(baseClassName, type.Base)
end

---@param obj any
---@param className string
---@return boolean hasBaseClass
function Class.HasBase(obj, className)
    ---@type Out<Freemaker.ClassSystem.Metatable>
    local metatable = {}
    if not Class.IsClass(obj, metatable) then
        return false
    end
    metatable = metatable.Value

    return Class.HasTypeBaseClass(className, metatable.Type)
end

---@param obj any
---@param metatableOut Out<Freemaker.ClassSystem.Metatable>?
---@return boolean isClass
function Class.IsClass(obj, metatableOut)
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

    if metatableOut then
        metatableOut.Value = metatable
    end

    return true
end

---@param class object
---@return Freemaker.ClassSystem.Type
---@diagnostic disable-next-line
function typeof(class)
    ---@type Freemaker.ClassSystem.Metatable
    local metatable = getmetatable(class)
    return metatable.Type
end

return Class

-- ############ ClassSystem ############ --
