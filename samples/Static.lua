---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.Raw : object
---@overload fun() : TestClass.Raw
local class = {}

function class.Static__foo()
    print("foo")
end

function class:foo()
    print("foo")
end

ClassSystem.Create(class, "Class Name")

local instance = class()

-- class:foo()
-- Will cause an error because class an template is and not an instance.

class.Static__foo()
instance.Static__foo()
-- Will work since all static values and function are accessible from the template and an instance.
