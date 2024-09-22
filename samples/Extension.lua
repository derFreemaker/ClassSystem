---@type class-system
local class_system = require("class_system")

---@class test-class.extension : object
---@overload fun() : test-class.extension
local test_class = {}
class("test-class", test_class)
local instance_before_extension = test_class()


---@class test-class.extension
local class_extensions = {}

function class_extensions:foo()
    print("foo")
end

class_extensions.foo_val = 100

class_system.extend(test_class, class_extensions)


local instance_after_extension = test_class()

instance_after_extension:foo()
instance_before_extension:foo()

local val1 = instance_after_extension.foo_val
local val2 = instance_before_extension.foo_val
-- All instances of the type get extended.
-- If an instance already has a value or function with the same key it will not be overridden.
