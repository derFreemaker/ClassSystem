---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.Extensions : object
---@overload fun() : TestClass.Extensions
local testClass = {}
class("Class Name", testClass)
local instanceBeforeExtension = testClass()


---@class TestClass.Extensions
local classExtensions = {}

function classExtensions:foo()
    print("foo")
end

classExtensions.fooVal = 100

ClassSystem.Extend(testClass, classExtensions)


local instanceAfterExtension = testClass()

instanceAfterExtension:foo()
instanceBeforeExtension:foo()

local val1 = instanceAfterExtension.fooVal
local val2 = instanceBeforeExtension.fooVal
-- All instances of the type get extended.
-- If an instance already has a value or function with the same name it will not be overridden.
