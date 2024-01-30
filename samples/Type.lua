---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.Type : object
---@overload fun() : TestClass.Type
local class = {}
ClassSystem.Create(class, "Class Name")

local type = ClassSystem.Typeof(class)
if not type then
    return
end

-- ! All of these values are not meant to be changed !

local Base = type.Base
-- Is the base type of the class. Default is object.

local HasClose = type.HasClose
-- Indicates if type has a __close meta method.

local HasConstructor = type.HasConstructor
-- Indicates if type has a __init function aka constructor.

local HasDeconstructor = type.HasDeconstructor
-- Indicates if type has a __gc meta method aka deconstructor/finisher.

local HasIndex = type.HasIndex
-- Indicates if type has a __index meta method invoked when getting a value from the class. (also functions)

local HasNewIndex = type.HasNewIndex
-- Indicates if type has a __newindex meta method invoked.

local Instances = type.Instances
-- All instances of the type.

local Members = type.Members
-- All members of the type.

local MetaMethods = type.MetaMethods
-- All metaMethods of the type.

local Name = type.Name
-- Name of the type.

local Options = type.Options
-- Has some options like if it is a abstract class

local Static = type.Static
-- Static Table in which all Static functions and values are stored.
-- Will be access when class.Static__Foo is used

local Blueprint = type.Blueprint
-- The table that gets produced from ClassSystem.Create.
-- Which acts as Blueprint to be constructed with. Will be nil if class is abstract
-- Can also access static members.
