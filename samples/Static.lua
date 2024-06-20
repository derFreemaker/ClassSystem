---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.Raw : object
---@overload fun() : TestClass.Raw
local testClass = {}

function testClass.Static__foo()
    print("foo")
end

function testClass:foo()
    print("foo")
end

class("Class Name", testClass)

local instance = testClass()

-- class:foo()
-- Will cause an error because class an template is and not an instance.

testClass.Static__foo()
instance.Static__foo()
-- Will work since all static values and function are accessible from the template and an instance.
