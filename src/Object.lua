local Utils = require("src.Utils")
local Config = require("src.Config")

---@class object
local Object = {}

---@protected
---@return string typeName
function Object:__tostring()
    return Utils.Class.Typeof(self).Name
end

---@protected
---@return string
function Object.__concat(left, right)
    return tostring(left) .. tostring(right)
end

---@class object.Modify
---@field CustomIndexing boolean?

---@protected
---@param func fun(modify: object.Modify)
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

----------------------------------------
-- Type Info
----------------------------------------

---@type Freemaker.ClassSystem.Type
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
