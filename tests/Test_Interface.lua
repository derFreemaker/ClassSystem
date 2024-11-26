package.path = "./?.lua;" .. package.path
local luaunit = require("tests.Luaunit")

local class_system = require("src.init")

function TestCreateInterfaceClass()
    local test_class = {}

    function test_class:foo()
    end
    test_class.foo = class_system.is_interface
    class_system.create(test_class, { name = "test-class", is_interface = true })

    luaunit.assertErrorMsgContains("cannot construct interface class: test-class", function()
        local _ = test_class()
    end)

    local interface_and_abstract_class = {}
    luaunit.assertErrorMsgContains("cannot mark class as interface and abstract class", function()
        class_system.create(interface_and_abstract_class, { name = "interface_and_abstract_test-class", is_abstract = true, is_interface = true })
    end)
end

function TestCreateClassWithInterface()
    local test_class = {}

    function test_class:foo()
    end
    test_class.foo = class_system.is_interface
    class_system.create(test_class, { name = "test-class", is_interface = true })

    local child_class = {}
    function child_class:foo()
        print("foo")
    end
    class_system.create(child_class, { name = "child_test-class", inherit = test_class })

    local instance = child_class()
    instance:foo()

    local error_class = {}
    luaunit.assertErrorMsgContains("error_test-class does not implement inherited interface member: test-class.foo", function()
        class_system.create(error_class, { name = "error_test-class", inherit = test_class })
    end)
end

os.exit(luaunit.LuaUnit.run())
