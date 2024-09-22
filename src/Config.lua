---@class class-system.configs
local configs = {}

--- All meta methods that should be added as meta method to the class.
configs.all_meta_methods = {
    --- Before Constructor
    __preinit = true,
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

--- Blocks meta methods on the blueprint of an class.
configs.block_meta_methods_on_blueprint = {
    __pairs = true,
    __ipairs = true
}

--- Blocks meta methods if not set by the class.
configs.block_meta_methods_on_instance = {
    __pairs = true,
    __ipairs = true
}

--- Meta methods that should not be set to the classes metatable, but remain in the type.MetaMethods.
configs.indirect_meta_methods = {
    __preinit = true,
    __gc = true,
    __index = true,
    __newindex = true
}

-- Indicates that the __close method is called from the ClassSystem.Deconstruct method.
configs.deconstructing = {}

-- Placeholder is used to indicate that this member should be set by super class of the abstract class
---@type any
configs.abstract_placeholder = {}

-- Placeholder is used to indicate that this member should be set by super class of the interface
---@type any
configs.interface_placeholder = {}

return configs
