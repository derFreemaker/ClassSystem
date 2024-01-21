---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.Extensions : object
---@overload fun() : TestClass.Extensions
local class = {}
ClassSystem.Create(class, "Class Name")
local instanceBeforeExtension = class()


---@class TestClass.Extensions
local classExtensions = {}

function classExtensions:foo()
    print("foo")
end

classExtensions.fooVal = 100

ClassSystem.Extend(class, classExtensions)


local instanceAfterExtension = class()

instanceAfterExtension:foo()
instanceBeforeExtension:foo()

local val1 = instanceAfterExtension.fooVal
local val2 = instanceBeforeExtension.fooVal
-- All instances of the type get extended.
-- If an instance already has a value or function with the same name it will not be overridden.
