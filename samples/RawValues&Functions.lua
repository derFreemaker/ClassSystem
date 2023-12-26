local ClassSystem = require("ClassSystem")

---@class TestClass.Raw : object
---@overload fun() : TestClass.Raw
local class = {}

function class:Raw__foo()
    print("foo")
end

function class:foo()
    print("foo")
end

function class:__index(key)
    return "some value"
end

ClassSystem.Create(class, "Class Name")

local instance = class()

instance:foo()
-- Will cause an error because the class:__index meta method returns "some value" and not the function class:foo.
-- If class:__index returns the exact table from ClassSystem.GetNormal it will also work.

instance:Raw__foo()
-- Will work because it ignores the class:__index method.
