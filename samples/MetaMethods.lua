local ClassSystem = require("ClassSystem")

---@class TestClass.MetaMethods : object
---@overload fun() : TestClass.MetaMethods
local class = {}

function class:__gc()
    print("garbage collection")
end

function class:__index(key)
    return "some value"
end

class.foo = 100

ClassSystem.Create(class, "Class Name")


local instance = class()

local val1, val2 = instance.foo, instance["foo"]
-- Invokes class:__index with key "foo".
-- Would return in this case "some value" instead of 100

---@diagnostic disable-next-line
instance = nil
collectgarbage()
-- Trigger gc to invoke class:__gc.

-- ## or ## --

ClassSystem.Deconstruct(instance)
-- Also triggers class:__gc.
-- And removes it after as well cleaning the table rendering it useless.
