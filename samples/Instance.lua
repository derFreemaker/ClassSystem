---@type class-system
local class_system = require("class_system")

---@class test-class.instance : object
---@overload fun() : test-class.instance
local test_class = {}
class("test-class", test_class)

local instance = test_class()

local instanceData = class_system.get_instance_data(instance)
if not instanceData then
    return
end

-- ! All of these values are not meant to be changed !

local CustomIndexing = instanceData.custom_indexing
-- Indicates if custom index is enabled.
-- If true will call __index or __newindex.
-- Default: true

local IsConstructed = instanceData.is_constructed
-- Indicates if instance is constructed.
-- Is only false while the constructor 'class:__init(...)' is getting executed.
