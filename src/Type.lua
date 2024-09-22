---@class class-system.type_handler
local type_handler = {}

---@param base class-system.type | nil
---@param interfaces table<class-system.type>
---@param options class-system.create.options
function type_handler.create(base, interfaces, options)
    local type_info = {
        name = options.name,
        base = base,
        interfaces = interfaces,

        options = options,

        meta_methods = {},
        members = {},
        static = {},

        instances = setmetatable({}, { __mode = "k" }),
    }

    options.name = nil
    options.inherit = nil
    ---@cast type_info class-system.type

    setmetatable(
        type_info,
        {
            __tostring = function(self)
                return self.Name
            end
        }
    )

    return type_info
end

return type_handler
