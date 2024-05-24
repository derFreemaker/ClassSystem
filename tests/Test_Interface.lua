local luaunit = require("tests.Luaunit")

local ClassSystem = require("src.init")

function TestCreateInterfaceClass()
    local testClass = {}

    function testClass:Foo()
    end
    testClass.Foo = ClassSystem.IsInterface
    ClassSystem.Create(testClass, { Name = "testClass", IsInterface = true })

    luaunit.assertErrorMsgContains("cannot construct interface class: testClass", function()
        local _ = testClass()
    end)

    local interfaceAndAbstractClass = {}
    luaunit.assertErrorMsgContains("cannot mark class as interface and abstract class", function()
        ClassSystem.Create(interfaceAndAbstractClass, { Name = "interfaceAndAbstractClass", IsAbstract = true, IsInterface = true })
    end)
end

function TestCreateClassWithInterface()
    local testClass = {}

    function testClass:Foo()
    end
    testClass.Foo = ClassSystem.IsInterface
    ClassSystem.Create(testClass, { Name = "testClass", IsInterface = true })

    local childClass = {}
    function childClass:Foo()
        print("foo")
    end
    ClassSystem.Create(childClass, { Name = "childClass", Inherit = testClass })

    local instance = childClass()
    instance:Foo()

    local errorClass = {}
    luaunit.assertErrorMsgContains("errorClass does not implement inherited interface member: object.Foo", function()
        ClassSystem.Create(errorClass, { Name = "errorClass", Inherit = testClass })
    end)
end

os.exit(luaunit.LuaUnit.run())
