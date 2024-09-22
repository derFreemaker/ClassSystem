---@type class-system
local class_system = require("class_system")

---@class test-class.type : object
---@overload fun() : test-class.type
local test_class = {}
class("test-class", test_class)

local type = class_system.typeof(test_class)
if not type then
    return
end

-- ! All of these values are not meant to be changed !

local type_name = type.name
-- Name of the type.

local type_base = type.base
-- Is the base type of the class. Default is object.

local type_has_close = type.has_close
-- Indicates if type has a __close meta method.

local type_has_pre_constructor = type.has_pre_constructor
-- Indicates if type has a __preinit function aka pre constructor.

local type_has_constructor = type.has_constructor
-- Indicates if type has a __init function aka constructor.

local type_has_deconstructor = type.has_deconstructor
-- Indicates if type has a __gc meta method aka deconstructor/finisher.

local type_has_index = type.has_index
-- Indicates if type has a __index meta method invoked when getting a value from the class. (also functions)

local type_has_new_index = type.has_new_index
-- Indicates if type has a __newindex meta method invoked.

local type_instances = type.instances
-- All instances of the type.

local type_members = type.members
-- All members of the type.

local type_meta_methods = type.meta_methods
-- All metaMethods of the type.

local type_options = type.options
-- Has some options like if it is a abstract class

local type_static = type.static
-- Static Table in which all Static functions and values are stored.
-- Will be access when class.Static__Foo is used

local type_blueprint = type.blueprint
-- The table that gets produced from ClassSystem.Create.
-- Which acts as Blueprint to be constructed with. Will be nil if class is abstract
-- Can also access static members.

local type_interfaces = type.interfaces
-- All the implemented interfaces.
