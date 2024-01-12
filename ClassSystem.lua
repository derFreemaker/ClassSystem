local __fileFuncs__ = {}
    local __cache__ = {}
    local function __loadFile__(module)
        if not __cache__[module] then
            __cache__[module] = { __fileFuncs__[module]() }
        end
        return table.unpack(__cache__[module])
    end
    __fileFuncs__["tools.Freemaker.bin.utils"] = function()
    local __fileFuncs__ = {}
        local __cache__ = {}
        local function __loadFile__(module)
            if not __cache__[module] then
                __cache__[module] = { __fileFuncs__[module]() }
            end
            return table.unpack(__cache__[module])
        end
        __fileFuncs__["src.Utils.String"] = function()
        local String = {}
        local function findNext(str, pattern, plain)
            local found = str:find(pattern, 0, plain or false)
            if found == nil then
                return nil, 0
            end
            return str:sub(0, found - 1), found - 1
        end
        function String.Split(str, sep, plain)
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
                local foundStr, foundPos = findNext(str, sep, plain)
                if foundStr == nil then
                    tbl[i] = str
                    return tbl
                end
                tbl[i] = foundStr
                str = str:sub(foundPos + sepLen + 1, strLen)
            end
        end
        function String.IsNilOrEmpty(str)
            if str == nil then
                return true
            end
            if str == "" then
                return true
            end
            return false
        end
        function String.Join(array, sep)
            local str = ""
            str = array[1]
            for _, value in next, array, 1 do
                str = str .. sep .. value
            end
            return str
        end
        return String
    end
    __fileFuncs__["src.Utils.Table"] = function()
        local Table = {}
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
        function Table.Copy(t)
            return copyTable(t, {}, {})
        end
        function Table.CopyTo(from, to)
            copyTable(from, to, {})
        end
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
        function Table.Contains(t, value)
            for _, tValue in pairs(t) do
                if value == tValue then
                    return true
                end
            end
            return false
        end
        function Table.ContainsKey(t, key)
            if t[key] ~= nil then
                return true
            end
            return false
        end
        function Table.Clean(t)
            for key, value in pairs(t) do
                for i = key - 1, 1, -1 do
                    if key ~= 1 then
                        if t[i] == nil and (t[i - 1] ~= nil or i == 1) then
                            t[i] = value
                            t[key] = nil
                            break
                        end
                    end
                end
            end
        end
        function Table.Count(t)
            local count = 0
            for _, _ in next, t, nil do
                count = count + 1
            end
            return count
        end
        function Table.Invert(t)
            local inverted = {}
            for key, value in pairs(t) do
                inverted[value] = key
            end
            return inverted
        end
        return Table
    end
    __fileFuncs__["src.Utils.Value"] = function()
        local Table = __loadFile__("src.Utils.Table")
        local Value = {}
        function Value.Copy(value)
            local typeStr = type(value)
            if typeStr == "table" then
                return Table.Copy(value)
            end
            return value
        end
        return Value
    end
    __fileFuncs__["__main__"] = function()
        local Utils = {}
        Utils.String = __loadFile__("src.Utils.String")
        Utils.Table = __loadFile__("src.Utils.Table")
        Utils.Value = __loadFile__("src.Utils.Value")
        return Utils
    end
    local main = __fileFuncs__["__main__"]()
    return main
end

__fileFuncs__["src.Config"] = function()
    local Configs = {}
    Configs.AllMetaMethods = {
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
    Configs.BlockMetaMethodsOnBlueprint = {
        __pairs = true,
        __ipairs = true
    }
    Configs.BlockMetaMethodsOnInstance = {
        __pairs = true,
        __ipairs = true
    }
    Configs.IndirectMetaMethods = {
        __gc = true,
        __index = true,
        __newindex = true
    }
    Configs.GetNormal = {}
    Configs.SetNormal = {}
    Configs.Deconstructing = {}
    Configs.Placeholder = {}
    return Configs
end

__fileFuncs__["src.ClassUtils"] = function()
    local Utils = {}
    local Class = {}
    function Class.Typeof(obj)
        if not type(obj) == "table" then
            return nil
        end
        local metatable = getmetatable(obj)
        return metatable.Type
    end
    function Class.Nameof(obj)
        local typeInfo = Class.Typeof(obj)
        if not typeInfo then
            return type(obj)
        end
        return typeInfo.Name
    end
    function Class.GetInstanceData(obj)
        if not Class.IsClass(obj) then
            return
        end
        ---@type Freemaker.ClassSystem.Metatable
        local metatable = getmetatable(obj)
        return metatable.Instance
    end
    function Class.IsClass(obj)
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
        return true
    end
    function Class.HasBase(obj, className)
        if not Class.IsClass(obj) then
            return false
        end
        local metatable = getmetatable(obj)
        ---@param typeInfo Freemaker.ClassSystem.Type
        local function hasTypeBase(typeInfo)
            local typeName = typeInfo.Name
            if typeName == className then
                return true
            end
            if typeName ~= "object" then
                return hasTypeBase(typeInfo.Base)
            end
            return false
        end
        return hasTypeBase(metatable.Type)
    end
    Utils.Class = Class
    return Utils
end

__fileFuncs__["src.Object"] = function()
    local Utils = __loadFile__("tools.Freemaker.bin.utils")
    local Config = __loadFile__("src.Config")
    local ClassUtils = __loadFile__("src.ClassUtils")
    local Object = {}
    function Object:__tostring()
        return ClassUtils.Class.Typeof(self).Name
    end
    function Object.__concat(left, right)
        return tostring(left) .. tostring(right)
    end
    function Object:Raw__ModifyBehavior(func)
        ---@type Freemaker.ClassSystem.Metatable
        local metatable = getmetatable(self)
        local modify = {
            CustomIndexing = metatable.Instance.CustomIndexing
        }
        func(modify)
        if modify.CustomIndexing ~= nil then
            metatable.Instance.CustomIndexing = modify.CustomIndexing
        end
    end
    local objectTypeInfo = {
        Name = "object",
        Base = nil,
        Static = {},
        MetaMethods = {},
        Members = {},
        HasConstructor = false,
        HasDeconstructor = false,
        HasClose = false,
        HasIndex = false,
        HasNewIndex = false,
        Instances = setmetatable({}, { __mode = 'k' })
    }
    for key, value in pairs(Object) do
        if Config.AllMetaMethods[key] then
            objectTypeInfo.MetaMethods[key] = value
        else
            if type(key) == 'string' then
                local splittedKey = Utils.String.Split(key, '__')
                if Utils.Table.Contains(splittedKey, 'Static') then
                    objectTypeInfo.Static[key] = value
                else
                    objectTypeInfo.Members[key] = value
                end
            else
                objectTypeInfo.Members[key] = value
            end
        end
    end
    return objectTypeInfo
end

__fileFuncs__["src.Type"] = function()
    local TypeHandler = {}
    function TypeHandler.Create(name, baseClass)
        local typeInfo = { Name = name }
        ---@cast typeInfo Freemaker.ClassSystem.Type
        typeInfo.Base = baseClass
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
    return TypeHandler
end

__fileFuncs__["src.Instance"] = function()
    local Utils = __loadFile__("tools.Freemaker.bin.utils")
    local InstanceHandler = {}
    function InstanceHandler.Initialize(instance)
        -- instance.Members = {}
        instance.CustomIndexing = true
    end
    function InstanceHandler.InitializeType(typeInfo)
        typeInfo.Instances = setmetatable({}, { __mode = "k" })
    end
    function InstanceHandler.Add(typeInfo, instance)
        typeInfo.Instances[instance] = true
        if typeInfo.Base then
            InstanceHandler.Add(typeInfo.Base, instance)
        end
    end
    function InstanceHandler.Remove(typeInfo, instance)
        typeInfo.Instances[instance] = nil
        if typeInfo.Base then
            InstanceHandler.Remove(typeInfo.Base, instance)
        end
    end
    function InstanceHandler.UpdateMetaMethod(typeInfo, name, func)
        typeInfo.MetaMethods[name] = func
        for instance in pairs(typeInfo.Instances) do
            local instanceMetatable = getmetatable(instance)
            if not Utils.Table.ContainsKey(instanceMetatable, name) then
                instanceMetatable[name] = func
            end
        end
    end
    function InstanceHandler.UpdateMember(typeInfo, key, value)
        typeInfo.Members[key] = value
        for instance in pairs(typeInfo.Instances) do
            if not Utils.Table.ContainsKey(instance, key) then
                instance.Members[key] = value
            end
        end
    end
    return InstanceHandler
end

__fileFuncs__["src.Members"] = function()
    local Utils = __loadFile__("tools.Freemaker.bin.utils")
    local Config = __loadFile__("src.Config")
    local InstanceHandler = __loadFile__("src.Instance")
    local MembersHandler = {}
    function MembersHandler.Initialize(typeInfo)
        typeInfo.Static = {}
        typeInfo.MetaMethods = {}
        typeInfo.Members = {}
    end
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
    function MembersHandler.SetStatic(typeInfo, key, value)
        if not assignStatic(typeInfo, key, value) then
            rawset(typeInfo.Static, key, value)
        end
    end
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
                if value ~= Config.GetNormal then
                    return value
                end
            end
            return rawget(obj, key)
        end
    end
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
                if typeInfo.MetaMethods.__newindex(obj, key, value) ~= Config.SetNormal then
                    return
                end
            end
            rawset(obj, key, value)
        end
    end
    local function isNormalFunction(typeInfo, name, func)
        if Utils.Table.ContainsKey(Config.AllMetaMethods, name) then
            typeInfo.MetaMethods[name] = func
            return
        end
        typeInfo.Members[name] = func
    end
    local function isNormalMember(typeInfo, name, value)
        if type(value) == 'function' then
            isNormalFunction(typeInfo, name, value)
            return
        end
        typeInfo.Members[name] = value
    end
    local function isStaticMember(typeInfo, name, value)
        typeInfo.Static[name] = value
    end
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
    local function UpdateMethods(typeInfo, name, func)
        if Utils.Table.ContainsKey(typeInfo.Members, name) then
            error("trying to extend already existing meta method: " .. name)
        end
        InstanceHandler.UpdateMetaMethod(typeInfo, name, func)
    end
    local function UpdateMember(typeInfo, key, value)
        if Utils.Table.ContainsKey(typeInfo.Members, key) then
            error("trying to extend already existing member: " .. tostring(key))
        end
        InstanceHandler.UpdateMember(typeInfo, key, value)
    end
    local function extendIsStaticMember(typeInfo, name, value)
        if Utils.Table.ContainsKey(typeInfo.Static, name) then
            error("trying to extend already existing static member: " .. name)
        end
        typeInfo.Static[name] = value
    end
    local function extendIsNormalFunction(typeInfo, name, func)
        if Utils.Table.ContainsKey(Config.AllMetaMethods, name) then
            UpdateMethods(typeInfo, name, func)
        end
        UpdateMember(typeInfo, name, func)
    end
    local function extendIsNormalMember(typeInfo, name, value)
        if type(value) == 'function' then
            extendIsNormalFunction(typeInfo, name, value)
            return
        end
        UpdateMember(typeInfo, name, value)
    end
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
    function MembersHandler.Extend(typeInfo, data)
        for key, value in pairs(data) do
            extendMember(typeInfo, key, value)
        end
        MembersHandler.UpdateState(typeInfo)
    end
    return MembersHandler
end

__fileFuncs__["src.Metatable"] = function()
    local Utils = __loadFile__("tools.Freemaker.bin.utils")
    local Config = __loadFile__("src.Config")
    local MembersHandler = __loadFile__("src.Members")
    local MetatableHandler = {}
    function MetatableHandler.Template(typeInfo)
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
            return typeInfo.Name .. ".Blueprint"
        end
        return metatable
    end
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
end

__fileFuncs__["src.Construction"] = function()
    local Utils = __loadFile__("tools.Freemaker.bin.utils")
    local Config = __loadFile__("src.Config")
    local InstanceHandler = __loadFile__("src.Instance")
    local MetatableHandler = __loadFile__("src.Metatable")
    local ConstructionHandler = {}
    local function construct(obj, ...)
        ---@type Freemaker.ClassSystem.Metatable
        local metatable = getmetatable(obj)
        local typeInfo = metatable.Type
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
    function ConstructionHandler.Template(data, typeInfo)
        local metatable = MetatableHandler.Template(typeInfo)
        metatable.__call = construct
        setmetatable(data, metatable)
    end
    local function invokeDeconstructor(typeInfo, class)
        if typeInfo.HasClose then
            typeInfo.MetaMethods.__close(class, Config.Deconstructing)
        end
        if typeInfo.HasDeconstructor then
            typeInfo.MetaMethods.__gc(class)
            invokeDeconstructor(typeInfo.Base, class)
        end
    end
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
end

__fileFuncs__["__main__"] = function()
    local Utils = __loadFile__("tools.Freemaker.bin.utils")
    local Config = __loadFile__("src.Config")
    local ClassUtils = __loadFile__("src.ClassUtils")
    local ObjectType = __loadFile__("src.Object")
    local TypeHandler = __loadFile__("src.Type")
    local MembersHandler = __loadFile__("src.Members")
    local InstanceHandler = __loadFile__("src.Instance")
    local ConstructionHandler = __loadFile__("src.Construction")
    local ClassSystem = {}
    ClassSystem.GetNormal = Config.GetNormal
    ClassSystem.SetNormal = Config.SetNormal
    ClassSystem.Deconstructed = Config.Deconstructing
    ClassSystem.Placeholder = Config.Placeholder
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
    function ClassSystem.Deconstruct(obj)
        ---@type Freemaker.ClassSystem.Metatable
        local metatable = getmetatable(obj)
        local instance = metatable.Instance
        local typeInfo = metatable.Type
        ConstructionHandler.Deconstruct(obj, metatable, instance, typeInfo)
    end
    ClassSystem.Typeof = ClassUtils.Class.Typeof
    ClassSystem.Nameof = ClassUtils.Class.Nameof
    ClassSystem.GetInstanceData = ClassUtils.Class.GetInstanceData
    ClassSystem.IsClass = ClassUtils.Class.IsClass
    ClassSystem.HasBase = ClassUtils.Class.HasBase
    return ClassSystem
end

return __fileFuncs__["__main__"]()
