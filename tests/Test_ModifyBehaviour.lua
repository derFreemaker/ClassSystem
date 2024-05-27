local luaunit = require("tests.Luaunit")

local ClassSystem = require("src.init")

function TestModifyBehavior()
    ---@class TestClass : object
    ---@overload fun() : TestClass
    local testClass = {}

    function testClass:__init()
        self:Raw__ModifyBehavior(function (modify)
            modify.CustomIndexing = false
        end)

        self.Test = 123
        local test = self.Test

        self:Raw__ModifyBehavior(function (modify)
            modify.CustomIndexing = true
        end)
    end

    function testClass:__newindex()
        error()
    end

    function testClass:__index()
        error()
    end

    ClassSystem.Create(testClass, { Name = "StaticTestClass" })
    local testClassInstance = testClass()
end

os.exit(luaunit.LuaUnit.run())
