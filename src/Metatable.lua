local utils = require("tools.utils")

local config = require("src.config")

local members_handler = require("src.members")

---@class class-system.metatable_handler
local metatable_handler = {}

---@param type_info class-system.type
---@return class-system.blueprint-metatable metatable
function metatable_handler.create_template_metatable(type_info)
    ---@type class-system.blueprint-metatable
    local metatable = { type = type_info }

    metatable.__index = members_handler.template_index(type_info)
    metatable.__newindex = members_handler.template_new_index(type_info)

    for key in pairs(config.block_meta_methods_on_blueprint) do
        local function blockMetaMethod()
            error("cannot use meta method: " .. key .. " on a template from a class")
        end
        ---@diagnostic disable-next-line: assign-type-mismatch
        metatable[key] = blockMetaMethod
    end

    metatable.__tostring = function()
        return type_info.name .. ".__blueprint__"
    end

    return metatable
end

---@param type_info class-system.type
---@param instance class-system.instance
---@param metatable class-system.metatable
function metatable_handler.create(type_info, instance, metatable)
    metatable.type = type_info

    metatable.__index = members_handler.instance_index(instance, type_info)
    metatable.__newindex = members_handler.instance_new_index(instance, type_info)

    for key, _ in pairs(config.block_meta_methods_on_instance) do
        if not utils.table.contains_key(type_info.meta_methods, key) then
            local function blockMetaMethod()
                error("cannot use meta method: " .. key .. " on class: " .. type_info.name)
            end
            metatable[key] = blockMetaMethod
        end
    end
end

return metatable_handler
