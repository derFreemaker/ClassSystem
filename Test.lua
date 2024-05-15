local Class = require("src.init")

---@generic TClass : object
---@param table TClass
---@param name string
---@param optionsOrInit Freemaker.ClassSystem.Create.Options | function | nil
---@param initOpt function | nil
---@return TClass
local function class(table, name, optionsOrInit, initOpt)
    local optionsOrInitT = type(optionsOrInit)
    if optionsOrInitT == "function" then
        if type(initOpt) == "function" then
            local inheritOrInitFunc = optionsOrInit
            local initOptFunc = initOpt
            initOpt = function()
                inheritOrInitFunc()
                initOptFunc()
            end
        else
            initOpt = optionsOrInit
        end
        optionsOrInit = { }
    end
    ---@cast optionsOrInit Freemaker.ClassSystem.Create.Options
    ---@cast initOpt function | nil

    if type(initOpt) == "function" then
        initOpt()
    end

    return Class.Create(table, name, optionsOrInit)
end

local TestClass = {}
class(TestClass, "TestClass", function()

function TestClass.Static__Test()

end

function TestClass:lol()

end

end)

local testClass = TestClass()

print("hi")