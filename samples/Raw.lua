---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.Raw : object
---@overload fun() : TestClass.Raw
local testClass = {}

function testClass.raw__foo()
    print("foo")
end

function testClass:foo()
    print("foo")
end

-- blocks every assignment to this class / object
function testClass:__newindex(key, value)
    error("can not set value: " .. key)
end

function testClass:disable_custom_indexing()
    self:Raw__ModifyBehavior(function (modify)
        modify.CustomIndexing = false
    end)
end

function testClass:enable_custom_indexing()
    self:Raw__ModifyBehavior(function (modify)
        modify.CustomIndexing = true
    end)
end

class("Class Name", testClass)

local instance = testClass()

---@diagnostic disable-next-line: duplicate-set-field
instance.raw__foo = function() end
-- Will work since all raw values and function don't invoke the "__newindex" meta method
-- and there for can always be set or called.
