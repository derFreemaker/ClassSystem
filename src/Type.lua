---@class Freemaker.ClassSystem.TypeHandler
local TypeHandler = {}

---@param name string
---@param baseClass Freemaker.ClassSystem.Type
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
