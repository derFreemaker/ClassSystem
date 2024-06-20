---@class Freemaker.ClassSystem.TypeHandler
local TypeHandler = {}

---@param base Freemaker.ClassSystem.Type | nil
---@param interfaces table<Freemaker.ClassSystem.Type>
---@param options Freemaker.ClassSystem.Create.Options
function TypeHandler.Create(base, interfaces, options)
    local typeInfo = {
        Name = options.Name,
        Base = base,
        Interfaces = interfaces,

        Options = options,

        MetaMethods = {},
        Members = {},
        Static = {},

        Instances = setmetatable({}, { __mode = "k" }),
    }

    options.Name = nil
    options.Inherit = nil
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
