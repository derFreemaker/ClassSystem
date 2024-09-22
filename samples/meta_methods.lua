---@type class-system
local class_system = require("class_system")

---@class test-class.meta_methods : object
---@overload fun() : test-class.meta_methods
local test_class = {}

---@private
function test_class:__gc()
    print("garbage collection")
end

---@private
function test_class:__index(key)
    return key .. " some value"
end

class("test-class", test_class)


local instance = test_class()

---@diagnostic disable-next-line
local val1 = instance.foo
-- Invokes class:__index with key "foo".

class_system.deconstruct(instance)
-- Triggers class:__gc.
-- And removes it after as well cleaning the table rendering the table useless.

---@diagnostic disable-next-line
instance = nil
collectgarbage()
-- Trigger gc to invoke class:__gc.
