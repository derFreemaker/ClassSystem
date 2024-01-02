local ClassSystem = require("src")
---@class TestClass.Type : object
---@overload fun() : TestClass.Type
local class = {}
ClassSystem.Create(class, "Class Name")

local type = ClassSystem.Typeof(class)
if not type then
    return
end

local name = type.Name
-- Name of the type.

local base = type.Base
-- Is the base type of the class. Default is object.
-- !! Will be nil if type is the object type.

local hasClose = type.HasClose
-- Indicates if type has a __close meta method.

local HasConstructor = type.HasConstructor
-- Indicates if type has a __init function aka constructor.

local HasDeconstructor = type.HasDeconstructor
-- Indicates if type has a __gc meta method aka deconstructor/finisher.

local HasIndex = type.HasIndex
-- Indicates if type has a __index meta method invoked when getting a value from the class. (also functions)

local HasNewIndex = type.HasNewIndex
-- Indicates if type has a __newindex meta method invoked.

local instances = type.Instances
-- All instances of the type.

local members = type.Members
-- All members of the type.

local metaMethods = type.MetaMethods
-- All metaMethods of the type.

local static = type.Static
-- Static Table in which all Static functions and values are stored.
-- Will be access when class.Static__Foo is used
