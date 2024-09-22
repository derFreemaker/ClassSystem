local luaunit = require("tests.Luaunit")

local class_system = require("src.init")

function TestCreateAbstractClass()
    local test_class = {}

    function test_class:foo()
    end

    test_class.foo = class_system.is_abstract

    class_system.create(test_class, { name = "test-class", is_abstract = true })

    luaunit.assertErrorMsgContains("cannot construct abstract class", test_class)
end

function TestCreateClassWithAbstractClassAsBase()
    local abstract_test_class = {}
    function abstract_test_class:foo()
    end

    abstract_test_class.foo = class_system.is_abstract
    class_system.create(abstract_test_class, { name = "abstract_test-class", is_abstract = true })

    local test_class = {}
    function test_class:foo2()
        print("foo")
    end

    local function error_because_of_not_implemented_member()
        class_system.create(test_class, { name = "test-class", inherit = abstract_test_class })
    end

    luaunit.assertErrorMsgContains("does not implement inherited abstract member", error_because_of_not_implemented_member)
end

function TestCreateClassWithAbstractMembers()
    local abstract_test_class = {}
    function abstract_test_class:foo()
    end

    abstract_test_class.foo = class_system.is_abstract

    local function error_because_of_not_marked_as_abstract_class()
        class_system.create(abstract_test_class, { name = "abstractTestClass" })
    end

    luaunit.assertErrorMsgContains("has abstract member/s but is not marked as abstract",
        error_because_of_not_marked_as_abstract_class)
end

function TestCreateAbstractClassWithInterfaces()
    local interface = {}
    interface.test = class_system.is_interface
    class_system.create(interface, { name = "interface", is_interface = true })

    local abstract_test_class = {}
    abstract_test_class.class = class_system.is_abstract
    class_system.create(abstract_test_class, { name = "abstract_test-class", is_abstract = true })

    local test_class = {}
    test_class.class = "set"
    test_class.test = "set"
    class_system.create(test_class, { name = "test-class" })
end

os.exit(luaunit.LuaUnit.run())
