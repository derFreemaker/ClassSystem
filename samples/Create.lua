---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.Create : object
---@overload fun() : TestClass.Create
local class = {}

---@private
function class:__init()
    print("constructor")
end

function class:foo()
    print("foo")
end

class.fooValue = 100

ClassSystem.Create(class, "Class Name")


local instance = class()
-- Triggers class:__init with self being set with all members added.

instance:foo()

local val = instance.fooValue
