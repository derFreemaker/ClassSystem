---@type class-system
local class_system = require("class_system")

---@class test-class.raw : object
---@overload fun() : test-class.raw
local test_class = {}

function test_class.raw__foo()
    print("foo")
end

function test_class:foo()
    print("foo")
end

-- blocks every assignment to this class / object
function test_class:__newindex(key, value)
    error("can not set value: " .. key)
end

function test_class:disable_custom_indexing()
    self:raw__modify_behavior(function (modify)
        modify.custom_indexing = false
    end)
end

function test_class:enable_custom_indexing()
    self:raw__modify_behavior(function (modify)
        modify.custom_indexing = true
    end)
end

class("test-class", test_class)

local instance = test_class()

---@diagnostic disable-next-line: duplicate-set-field
instance.raw__foo = function() end
-- Will work since all raw values and function don't invoke the "__newindex" meta method
-- and there for can always be set or called.
