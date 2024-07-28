---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.Interface
local testInterface = {}

function testInterface:foo()
end
testInterface.foo = ClassSystem.IsInterface

---@type integer
testInterface.fooValue = ClassSystem.IsInterface

interface("interface", testInterface)
-- If IsInterface is not set in options, will throw an error since not interfaces has interface members.
-- Also as you might notice all classes have `object` as base class interfaces don't.

local instance = testInterface()
-- Will throw an error since interfaces cannot be constructed

----------------------------------------------------------------
-- using interface class as base class
----------------------------------------------------------------

-- have to inherit `object` as well since TestClass.Interface is only a interface

---@class TestClass.NotInterface : object, TestClass.Interface
---@overload fun() : TestClass.NotInterface
local notInterface = {}

---@private
function notInterface:__init()
    print("constructor")
end

function notInterface:foo()
    print("foo")
end

-- Has to implement foo since its inherited this interface member from TestClass.Interface
-- If not will throw an error at ClassSystem.Create

notInterface.fooValue = 100
-- Has to implement fooValue since its inherited this interface member from TestClass.Interface
-- If not will throw an error at ClassSystem.Create

class("notInterface", notInterface, { Inherit = testInterface })
-- Inherit can have an table with multiple interfaces and one base class set in form of an array.
-- If not all interface members are implemented an error will occur.
