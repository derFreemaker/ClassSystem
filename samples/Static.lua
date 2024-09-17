---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.Static : object
---@overload fun() : TestClass.Static
local testClass = {}

function testClass.static__foo()
    print("foo")
end

function testClass:foo()
    print("foo")
end

class("Class Name", testClass)

local instance = testClass()

-- class:foo()
-- Will cause an error because class an template is and not an instance.

testClass.static__foo()
instance.static__foo()
-- Will work since all static values and function are accessible from the template and an instance.
-- It will search for "static" but name gets lowered so every "static" is valid
