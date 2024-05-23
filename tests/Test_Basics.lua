local luaunit = require("tests.Luaunit")

local ClassSystem = require("src.init")

function TestCreateClass()
    local test = ClassSystem.Create({}, { Name = "CreateEmpty" })

    luaunit.assertNotIsNil(test)
end

function TestCreateClassWithBaseClass()
    local testBaseClass = ClassSystem.Create({}, { Name = "EmptyBaseClass" })
    local test = ClassSystem.Create({}, { Name = "CreateEmptyWithBaseClass", BaseClass = testBaseClass })

    luaunit.assertNotIsNil(test)
end

function TestConstructClass()
    local test = ClassSystem.Create({}, { Name = "CreateEmpty" })

    luaunit.assertNotIsNil(test())
end

function TestExtendClass()
    local test = ClassSystem.Create({}, { Name = "CreateEmpty" })
    local testClassInstance = test()

    local testBaseClass = ClassSystem.Create({}, { Name = "CreateEmptyWithBaseClass", Inherit = test })
    local testBaseClassInstance = testBaseClass()

    local extended = ClassSystem.Extend(test, { Test = "hi" })

    local extendedTestClassInstance = test()
    local extendedTestBaseClass = testBaseClass()
    local extendedClassInstance = extended()

    luaunit.assertEquals(testClassInstance.Test, "hi")
    luaunit.assertEquals(testBaseClassInstance.Test, "hi")
    luaunit.assertEquals(extendedTestClassInstance.Test, "hi")
    luaunit.assertEquals(extendedTestBaseClass.Test, "hi")
    luaunit.assertEquals(extendedClassInstance.Test, "hi")
end

function TestDeconstructClass()
    local testClass = ClassSystem.Create({}, { Name = "CreateEmpty" })
    local test = testClass()
    local function throwErrorBecauseOfDeconstructedClass()
        _ = test.hi
    end

    ClassSystem.Deconstruct(test)

    luaunit.assertErrorMsgContains("cannot get values from deconstruct class: CreateEmpty",
        throwErrorBecauseOfDeconstructedClass)
end

os.exit(luaunit.LuaUnit.run())
