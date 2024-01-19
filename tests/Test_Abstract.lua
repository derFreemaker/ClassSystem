--//TODO: create abstract tests

local luaunit = require("tests.Luaunit")

local ClassSystem = require("src")

function TestCreateAbstractClass()
    local testClass = {}

    function testClass:foo()
    end

    testClass.foo = ClassSystem.IsAbstract

    ClassSystem.Create(testClass, "testClass", nil, { IsAbstract = true })

    luaunit.assertErrorMsgContains("cannot construct abstract class", testClass)
end

function TestCreateClassWithAbstractClassAsBase()
    local abstractTestClass = {}
    function abstractTestClass:foo()
    end

    abstractTestClass.foo = ClassSystem.IsAbstract
    ClassSystem.Create(abstractTestClass, "abstractTestClass", nil, { IsAbstract = true })

    local testClass = {}
    function testClass:foo2()
        print("foo")
    end

    local function errorBecauseOfNotImplementedMember()
        ClassSystem.Create(testClass, "testClass", abstractTestClass)
    end

    luaunit.assertErrorMsgContains("does not implement inherited abstract member", errorBecauseOfNotImplementedMember)
end

function TestCreateClassWithAbstractMembers()
    local abstractTestClass = {}
    function abstractTestClass:foo()
    end

    abstractTestClass.foo = ClassSystem.IsAbstract

    local function errorBecauseOfNotMarkedAsAbstract()
        ClassSystem.Create(abstractTestClass, "abstractTestClass")
    end

    luaunit.assertErrorMsgContains("has abstract member/s but is not marked as abstract",
        errorBecauseOfNotMarkedAsAbstract)
end

os.exit(luaunit.LuaUnit.run())
