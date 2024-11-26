local utils = require("tools.utils")

---@class class-system.instance_handler
local instance_handler = {}

---@param instance class-system.instance
function instance_handler.initialize(instance)
    instance.custom_indexing = true
    instance.is_constructed = false
end

---@param type_info class-system.type
---@param instance object
function instance_handler.add(type_info, instance)
    type_info.instances[instance] = true

    if type_info.base then
        instance_handler.add(type_info.base, instance)
    end

    for _, parent in pairs(type_info.interfaces) do
        instance_handler.add(parent, instance)
    end
end

---@param type_info class-system.type
---@param instance object
function instance_handler.remove(type_info, instance)
    type_info.instances[instance] = nil

    if type_info.base then
        instance_handler.remove(type_info.base, instance)
    end

    for _, parent in pairs(type_info.interfaces) do
        instance_handler.remove(parent, instance)
    end
end

---@param type_info class-system.type
---@param name string
---@param func function
function instance_handler.update_meta_method(type_info, name, func)
    type_info.meta_methods[name] = func

    for instance in pairs(type_info.instances) do
        local instanceMetatable = getmetatable(instance)

        if not utils.table.contains_key(instanceMetatable, name) then
            instanceMetatable[name] = func
        end
    end
end

---@param type_info class-system.type
---@param key any
---@param value any
function instance_handler.update_member(type_info, key, value)
    type_info.members[key] = value

    for instance in pairs(type_info.instances) do
        if not utils.table.contains_key(instance, key) then
            rawset(instance, key, value)
        end
    end
end

return instance_handler
