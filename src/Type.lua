---@class Freemaker.ClassSystem.TypeHandler
local TypeHandler = {}

---@param name string
---@param baseClass Freemaker.ClassSystem.Type
---@param options Freemaker.ClassSystem.Type.Options
function TypeHandler.Create(name, baseClass, options)
    local typeInfo = {
        Name = name,
        Base = baseClass,
        Options = options
    }
    ---@cast typeInfo Freemaker.ClassSystem.Type

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
