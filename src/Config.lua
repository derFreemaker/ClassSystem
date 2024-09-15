---@class Freemaker.ClassSystem.Configs
local Configs = {}

--- All meta methods that should be added as meta method to the class.
Configs.AllMetaMethods = {
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
Configs.BlockMetaMethodsOnBlueprint = {
    __pairs = true,
    __ipairs = true
}

--- Blocks meta methods if not set by the class.
Configs.BlockMetaMethodsOnInstance = {
    __pairs = true,
    __ipairs = true
}

--- Meta methods that should not be set to the classes metatable, but remain in the type.MetaMethods.
Configs.IndirectMetaMethods = {
    __preinit = true,
    __gc = true,
    __index = true,
    __newindex = true
}

-- Indicates that the __close method is called from the ClassSystem.Deconstruct method.
Configs.Deconstructing = {}

-- Placeholder is used to indicate that this member should be set by super class of the abstract class
---@type any
Configs.AbstractPlaceholder = {}

-- Placeholder is used to indicate that this member should be set by super class of the interface
---@type any
Configs.InterfacePlaceholder = {}

return Configs
