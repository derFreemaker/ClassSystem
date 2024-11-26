package.path = "./?.lua;" .. package.path
local luaunit = require("tests.Luaunit")

local class_system = require("src.init")

function TestStaticAccess()
    local test_class = class_system.create({ static__test = "hi" }, { name = "static_test-class" })
    local test_class_instance = test_class()

    luaunit.assertEquals(test_class_instance.static__test, "hi")

    test_class.static__test = "hello"

    luaunit.assertEquals(test_class.static__test, "hello")
    luaunit.assertEquals(test_class_instance.static__test, "hello")

    class_system.deconstruct(test_class_instance)
    local function error_because_of_deconstructed_class()
        _ = test_class_instance.static__test
    end

    luaunit.assertErrorMsgContains("cannot get values from deconstruct class: static_test-class",
        error_because_of_deconstructed_class)
end

function TestRawAccess()
    local test_class = class_system.create({
        raw__test = "hi",
        __newindex = function(self)
            error("blocked new index")
        end
    }, { name = "test-class" })
    local test_class_instance_1 = test_class()
    local test_class_instance_2 = test_class()

    test_class_instance_1.raw__test = "hello"

    luaunit.assertEquals(test_class_instance_1.raw__test, "hello")
    luaunit.assertEquals(test_class_instance_2.raw__test, "hi")

    local function error_because_of_not_constructed_class()
        _ = test_class.raw__test
    end

    luaunit.assertErrorMsgContains("can only use static members in template", error_because_of_not_constructed_class)
end

function TestMetaMethod()
    local test_class = class_system.create({
        __gc = function(self)
            error("gc error")
        end
    }, { name = "test-class" })
    local instance = test_class()

    local function error_because_of_error_in_gc()
        class_system.deconstruct(instance)
    end

    luaunit.assertErrorMsgContains("gc error", error_because_of_error_in_gc)
end

os.exit(luaunit.LuaUnit.run())
