local utils = require("tools.utils")
local config = require("src.config")
local class = require("src.class")

---@class object
local object = {}

---@protected
---@return string typeName
function object:__tostring()
    return class.typeof(self).name
end

---@protected
---@return string
function object.__concat(left, right)
    return tostring(left) .. tostring(right)
end

---@class class-system.object.modify
---@field custom_indexing boolean | nil

---@protected
---@param func fun(modify: class-system.object.modify)
function object:raw__modify_behavior(func)
    ---@type class-system.metatable
    local metatable = getmetatable(self)

    local modify = {
        custom_indexing = metatable.instance.custom_indexing
    }

    func(modify)

    metatable.instance.custom_indexing = modify.custom_indexing
end

----------------------------------------
-- Type Info
----------------------------------------

---@type class-system.type
local object_type_info = {
    name = "object",
    base = nil,
    interfaces = {},

    static = {},
    meta_methods = {},
    members = {},

    has_pre_constructor = false,
    has_constructor = false,
    has_deconstructor = false,
    has_close = false,
    has_index = false,
    has_new_index = false,

    options = {
        is_abstract = true,
    },

    instances = setmetatable({}, { __mode = 'k' }),

    -- no blueprint since cannot be constructed
    blueprint = nil
}

for key, value in pairs(object) do
    if config.all_meta_methods[key] then
        object_type_info.meta_methods[key] = value
    else
        if type(key) == 'string' then
            local splittedKey = utils.string.split(key, '__')
            if utils.table.contains(splittedKey, 'Static') then
                object_type_info.static[key] = value
            else
                object_type_info.members[key] = value
            end
        else
            object_type_info.members[key] = value
        end
    end
end

setmetatable(
        object_type_info,
        {
            __tostring = function(self)
                return self.Name
            end
        }
    )

return object_type_info
