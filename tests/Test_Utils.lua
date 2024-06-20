local luaunit = require("tests.Luaunit")

local ClassSystem = require("src.init")

function TestModifyBehavior()
    ---@class TestModifyBehaviorClass : object
    ---@overload fun() : TestModifyBehaviorClass
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

    ClassSystem.Create(testClass, { Name = "TestModifyBehaviorClass" })
    local testClassInstance = testClass()
end

function TestDeconstructing()
    local correctErrObj = false

    ---@class TestDeconstructingClass : object
    ---@overload fun() : TestDeconstructingClass
    local testClass = {}

    function testClass:__close(errObj)
        correctErrObj = errObj == ClassSystem.Deconstructing
    end

    ClassSystem.Create(testClass, { Name = "TestDeconstructingClass" })
    local instance = testClass()

    ClassSystem.Deconstruct(instance)

    luaunit.assertIsTrue(correctErrObj, "errObj was not passed correctly")
end

function TestTypeof()
    local CLASS_NAME = "TestTypeofClass"

    ---@class TestTypeofClass : object
    ---@overload fun() : TestTypeofClass
    local testClass = {}
    ClassSystem.Create(testClass, { Name = CLASS_NAME })
    local instance = testClass()

    local typeInfo = ClassSystem.Typeof(instance)
    if not typeInfo then
        luaunit.fail("Typeof returned nil")
        return
    end

    luaunit.assertEquals(typeInfo.Name, CLASS_NAME, "class name in type info is not the same")
end

function TestNameof()
    local CLASS_NAME = "TestNameofClass"

    ---@class TestNameofClass : object
    ---@overload fun() : TestTypeofClass
    local testClass = {}
    ClassSystem.Create(testClass, { Name = CLASS_NAME })
    local instance = testClass()

    local className = ClassSystem.Nameof(instance)
    if not className then
        luaunit.fail("Nameof returned nil")
        return
    end

    luaunit.assertEquals(className, CLASS_NAME, "class name is not the same")
end

function TestGetInstanceData()
    ---@class TestGetInstanceDataClass : object
    ---@overload fun() : TestGetInstanceDataClass
    local testClass = {}
    ClassSystem.Create(testClass, { Name = "TestGetInstanceDataClass" })
    local instance = testClass()

    local instanceData = ClassSystem.GetInstanceData(instance)
    if not instanceData then
        luaunit.fail("GetInstanceData returned nil")
        return
    end

    luaunit.assertIsTrue(instanceData.IsConstructed)
end

function TestIsClass()
    ---@class TestIsClass : object
    ---@overload fun() : TestIsClass
    local testClass = {}
    ClassSystem.Create(testClass, { Name = "TestIsClass" })
    local instance = testClass()

    luaunit.assertIsTrue(ClassSystem.IsClass(instance))
end

function TestHasBase()
    ---@class TestHasBaseClassBaseClass : object
    ---@overload fun() : TestHasBaseClassBaseClass
    local testBaseClass = {}
    ClassSystem.Create(testBaseClass, { Name = "TestHasBaseClassBaseClass" })

    ---@class TestHasBaseClass : object
    ---@overload fun() : TestHasBaseClass
    local testClass = {}
    ClassSystem.Create(testClass, { Name = "TestHasBaseClass", Inherit = testBaseClass })
    local instance = testClass()

    luaunit.assertIsTrue(ClassSystem.HasBase(instance, "TestHasBaseClassBaseClass"))
end

function TestHasInterface()
    ---@class TestHasInterfaceInterface : object
    ---@overload fun() : TestHasInterfaceInterface
    local testInterface = {}
    ClassSystem.Create(testInterface, { Name = "TestHasInterfaceInterface", IsInterface = true })

    ---@class TestHasInterfaceClass : object
    ---@overload fun() : TestHasInterfaceClass
    local testClass = {}
    ClassSystem.Create(testClass, { Name = "TestHasInterfaceClass", Inherit = testInterface })
    local instance = testClass()

    luaunit.assertIsTrue(ClassSystem.HasInterface(instance, "TestHasInterfaceInterface"))
end

os.exit(luaunit.LuaUnit.run())
