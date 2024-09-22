---@type class-system
local class_system = require("class_system")

---@class test-class.create : object
---@overload fun() : test-class.create
local test_class = {}

-- pre constructor if returns value other than `nil` will skip class construction and return the result
-- recieves the same arguments like `class:__init`
-- useful for caching instances
---@private
---@return any
function test_class:__preinit(...)
    return nil
end

-- class constructor
---@private
function test_class:__init(...)
    print("constructor")
end

function test_class:foo()
    print("foo")
end

test_class.foo_value = 100

class("test-class", test_class)
-- does the same as
-- ClassSystem.Create(class, { Name = "Class Name" })
-- just makes it prettier

local instance = test_class()
-- Triggers class:__init with self being set with all members added.

instance:foo()

local val = instance.foo_value
