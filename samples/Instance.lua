local ClassSystem = require("src")
---@class TestClass.Instance : object
---@overload fun() : TestClass.Instance
local class = {}
ClassSystem.Create(class, "Class Name")

local instance = class()

local instanceData = ClassSystem.GetInstanceData(instance)
if not instanceData then
    return
end

local members = instanceData.Members
-- All the members of the current instance of the type.
-- Here are all members stored so the `__index` meta method is called every time when getting a value.

local customIndexing = instanceData.CustomIndexing
-- Indicates if the class instance of the type has custom indexing enabled.
-- If `false` then `class:__index` and `class:__newindex` will not be called.
-- Can be set with the class:Raw__ModifyBehavior() function.
