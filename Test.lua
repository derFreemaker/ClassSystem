local Class = require("src.init")

---@param table table
---@param name string
---@param optionsOrInit Freemaker.ClassSystem.Create.Options | function | nil
---@param initOpt function | nil
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

    Class.Create(table, name, optionsOrInit)
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