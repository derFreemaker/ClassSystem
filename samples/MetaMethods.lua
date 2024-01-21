---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.MetaMethods : object
---@overload fun() : TestClass.MetaMethods
local class = {}

---@private
function class:__gc()
    print("garbage collection")
end

---@private
function class:__index(key)
    return key .. " some value"
end

ClassSystem.Create(class, "Class Name")


local instance = class()

---@diagnostic disable-next-line
local val1 = instance.foo
-- Invokes class:__index with key "foo".

ClassSystem.Deconstruct(instance)
-- Triggers class:__gc.
-- And removes it after as well cleaning the table rendering the table useless.

---@diagnostic disable-next-line
instance = nil
collectgarbage()
-- Trigger gc to invoke class:__gc.
