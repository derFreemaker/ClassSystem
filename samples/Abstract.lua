---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.Abstract : object
local abstract = {}

function abstract:foo()
end

abstract.foo = ClassSystem.IsAbstract

---@type integer
abstract.fooValue = ClassSystem.IsAbstract

class("abstract", abstract, { IsAbstract = true })
-- If IsAbstract is not set in options, will throw an error since not abstract class has abstract members.

local instance = abstract()
-- Will throw an error since abstract classes cannot be constructed

----------------------------------------------------------------
-- using abstract class as base class
----------------------------------------------------------------

---@class TestClass.NotAbstract : TestClass.Abstract
---@overload fun() : TestClass.NotAbstract
local notAbstract = {}

---@private
function notAbstract:__init()
    print("constructor")
end

function notAbstract:foo()
    print("foo")
end

-- Has to implement foo since its inherited this abstract member from TestClass.Abstract
-- If not will throw an error at ClassSystem.Create

notAbstract.fooValue = 100
-- Has to implement fooValue since its inherited this abstract member from TestClass.Abstract
-- If not will throw an error at ClassSystem.Create

ClassSystem.Create(notAbstract, { Name = "notAbstract", Inherit = abstract })
-- Inherit can have an table with multiple interfaces and one base class set in form of an array.
-- If not all abstract members are implemented an error will occur.
