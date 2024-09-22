---@type class-system
local class_system = require("class_system")

---@class test-class.static : object
---@overload fun() : test-class.static
local test_class = {}

function test_class.static__foo()
    print("foo")
end

function test_class:foo()
    print("foo")
end

class("test-class", test_class)

local instance = test_class()

-- class:foo()
-- Will cause an error because class an template is and not an instance.

test_class.static__foo()
instance.static__foo()
-- Will work since all static values and function are accessible from the template and an instance.
-- It will split the name with '__' and search for "static" the name gets lowered so every version of "static" is valid
