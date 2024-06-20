---@type Freemaker.ClassSystem
local ClassSystem = require("ClassSystem")

---@class TestClass.Instance : object
---@overload fun() : TestClass.Instance
local testClass = {}
class("Class Name", testClass)

local instance = testClass()

local instanceData = ClassSystem.GetInstanceData(instance)
if not instanceData then
    return
end

-- ! All of these values are not meant to be changed !

local CustomIndexing = instanceData.CustomIndexing
-- Indicates if custom index is enabled.
-- If true will call __index or __newindex.
-- Default: true

local IsConstructed = instanceData.IsConstructed
-- Indicates if instance is constructed.
-- Is only false while the constructor (__init) is getting executed.
