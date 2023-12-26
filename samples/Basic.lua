local ClassSystem = require("ClassSystem")

---@class TestClass.Basic : object
---@overload fun() : TestClass.Basic
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
-- Triggers class:__init with self being set with all members and all meta methods added.

instance:foo()

local val = instance.fooValue
