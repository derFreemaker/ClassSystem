---@type class-system
local class_system = require("class_system")

---@class test-class.abstract : object
local abstract = {}

function abstract:foo()
end

abstract.foo = class_system.is_abstract

---@type integer
abstract.fooValue = class_system.is_abstract

class("abstract", abstract, { is_abstract = true })
-- If IsAbstract is not set in options, will throw an error since not abstract class has abstract members.

local instance = abstract()
-- Will throw an error since abstract classes cannot be constructed

----------------------------------------------------------------
-- using abstract class as base class
----------------------------------------------------------------

---@class test-class.not_abstract : test-class.abstract
---@overload fun() : test-class.not_abstract
local not_abstract = {}

---@private
function not_abstract:__init()
    print("constructor")
end

function not_abstract:foo()
    print("foo")
end

-- Has to implement foo since its inherited this abstract member from test-class.abstract
-- If not will throw an error at class_system.create.

not_abstract.fooValue = 100
-- Has to implement fooValue since its inherited this abstract member from test-class.abstract
-- If not will throw an error at class_system.create.

class_system.create(not_abstract, { name = "not_abstract", inherit = abstract })
-- Inherit can have an table with multiple interfaces and one base class set in form of an array.
-- If not all abstract members are implemented an error will occur.
