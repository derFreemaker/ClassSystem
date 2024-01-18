---@class Freemaker.ClassSystem.TypeHandler
local TypeHandler = {}

---@param name string
---@param baseClass Freemaker.ClassSystem.Type
---@param options Freemaker.ClassSystem.Create.Options
function TypeHandler.Create(name, baseClass, options)
    local typeInfo = { Name = name, IsAbstract = options.IsAbstract }
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
