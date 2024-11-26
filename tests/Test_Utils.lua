package.path = "./?.lua;" .. package.path
local luaunit = require("tests.Luaunit")

local class_system = require("src.init")

function TestModifyBehavior()
    ---@class modify_behavior_test-class : object
    ---@overload fun() : modify_behavior_test-class
    local test_class = {}

    function test_class:__init()
        self:raw__modify_behavior(function (modify)
            modify.custom_indexing = false
        end)

        self.test = 123

        self:raw__modify_behavior(function (modify)
            modify.custom_indexing = true
        end)
    end

    function test_class:__newindex()
        error()
    end

    function test_class:__index()
        error()
    end

    class_system.create(test_class, { name = "modify_behavior_test-class" })
    local test_class_instance = test_class()
end

function TestDeconstructing()
    local correct_err_obj = false

    ---@class deconstructing_test-class : object
    ---@overload fun() : deconstructing_test-class
    local test_class = {}

    function test_class:__close(errObj)
        correct_err_obj = errObj == class_system.deconstructing
    end

    class_system.create(test_class, { name = "deconstructing_test-class" })
    local instance = test_class()

    class_system.deconstruct(instance)

    luaunit.assertIsTrue(correct_err_obj, "err_obj was not passed correctly")
end

function TestTypeof()
    local class_name = "typeof_test-class"

    ---@class typeof_test-class : object
    ---@overload fun() : typeof_test-class
    local test_class = {}
    class_system.create(test_class, { name = class_name })
    local instance = test_class()

    local type_info = class_system.typeof(instance)
    if not type_info then
        luaunit.fail("typeof returned nil")
        return
    end

    luaunit.assertEquals(type_info.name, class_name, "class name in type info is not the same")
end

function TestNameof()
    local class_name = "nameof_test-class"

    ---@class nameof_test-class : object
    ---@overload fun() : typeof_test-class
    local test_class = {}
    class_system.create(test_class, { name = class_name })
    local instance = test_class()

    local actual_class_name = class_system.nameof(instance)
    if not actual_class_name then
        luaunit.fail("nameof returned nil")
        return
    end

    luaunit.assertEquals(actual_class_name, class_name, "class name is not the same")
end

function TestGetInstanceData()
    ---@class get_instance_data_test-class : object
    ---@overload fun() : get_instance_data_test-class
    local test_class = {}
    class_system.create(test_class, { name = "get_instance_data_test-class" })
    local instance = test_class()

    local instanceData = class_system.get_instance_data(instance)
    if not instanceData then
        luaunit.fail("get_instance_data returned nil")
        return
    end

    luaunit.assertIsTrue(instanceData.is_constructed)
end

function TestIsClass()
    ---@class is_class_test-class : object
    ---@overload fun() : is_class_test-class
    local test_class = {}
    class_system.create(test_class, { name = "is_class_test-class" })
    local instance = test_class()

    luaunit.assertIsTrue(class_system.is_class(instance))
end

function TestHasBase()
    local base_class_name = "has_base_class_test-base-class"

    ---@class has_base_class_test-base-class : object
    ---@overload fun() : has_base_class_test-base-class
    local test_base_class = {}
    class_system.create(test_base_class, { name = base_class_name })

    ---@class has_base_class_test-class : object
    ---@overload fun() : has_base_class_test-class
    local test_class = {}
    class_system.create(test_class, { name = "has_base_class_test-class", inherit = test_base_class })
    local instance = test_class()

    luaunit.assertIsTrue(class_system.has_base(instance, base_class_name))
end

function TestHasInterface()
    local interface_class_name = "has_interface_test-interafce-class"

    ---@class has_interface_test-interface-class : object
    ---@overload fun() : has_interface_test-interface-class
    local interface_test_class = {}
    class_system.create(interface_test_class, { name = interface_class_name, is_interface = true })

    ---@class has_interface_test-class : object
    ---@overload fun() : has_interface_test-class
    local test_class = {}
    class_system.create(test_class, { name = "has_interface_test-class", inherit = interface_test_class })
    local instance = test_class()

    luaunit.assertIsTrue(class_system.has_interface(instance, interface_class_name))
end

os.exit(luaunit.LuaUnit.run())
