local luaunit = require("tests.Luaunit")

local ClassSystem = require("src.init")

function TestStaticAccess()
    local testClass = ClassSystem.Create({ Static__Test = "hi" }, "StaticTestClass")
    local testClassInstance = testClass()

    luaunit.assertEquals(testClassInstance.Static__Test, "hi")

    testClass.Static__Test = "hello"

    luaunit.assertEquals(testClass.Static__Test, "hello")
    luaunit.assertEquals(testClassInstance.Static__Test, "hello")

    ClassSystem.Deconstruct(testClassInstance)
    local function throwErrorBecauseOfDeconstructedClass()
        _ = testClassInstance.Static__Test
    end

    luaunit.assertErrorMsgContains("cannot get values from deconstruct class: StaticTestClass",
        throwErrorBecauseOfDeconstructedClass)
end

function TestRawAccess()
    local testClass = ClassSystem.Create({
        Raw__Test = "hi"
    }, 'CreateEmpty')
    local testClassInstance1 = testClass()
    local testClassInstance2 = testClass()

    testClassInstance1.Raw__Test = "hello"

    luaunit.assertEquals(testClassInstance1.Raw__Test, "hello")
    luaunit.assertEquals(testClassInstance2.Raw__Test, "hi")

    local function throwErrorBecauseOfNotConstructedClass()
        _ = testClass.Raw__Test
    end

    luaunit.assertErrorMsgContains("can only use static members in template", throwErrorBecauseOfNotConstructedClass)
end

function TestMetaMethod()
    local testClass = ClassSystem.Create({
        __gc = function(self)
            error("gc error")
        end
    }, "TestMetaMethod")
    local instance = testClass()

    local function throwErrorBecauseOfErrorInGC()
        ClassSystem.Deconstruct(instance)
    end

    luaunit.assertErrorMsgContains("gc error", throwErrorBecauseOfErrorInGC)
end

os.exit(luaunit.LuaUnit.run())
