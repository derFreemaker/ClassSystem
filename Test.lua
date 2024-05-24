require("src.init")

---@class TestClass : object
---@overload fun() : TestClass
local TestClass = {}
class("TestClass", TestClass, function()

---@private
function TestClass.__init()
    print("constructed TestClass")
end

function TestClass.Static__Test()

end

function TestClass:foo()
    print("foo")
end

end)

local testClass = TestClass()
