local luaunit = require("tests.Luaunit")
local Functions = require("tests.functions")
local ClassSystem = require("src.init")

function TestCreateClassBenchmark()
    local testClass = {}
    ClassSystem.Create(testClass, { Name = "testClass" })

    local function createClass()
        local instance = testClass()
    end

    Functions.benchmarkFunction(createClass, 100000)
end

os.exit(luaunit.LuaUnit.run())