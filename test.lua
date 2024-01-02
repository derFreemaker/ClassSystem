local ClassSystem = require("src")

local testClass = {}

function testClass:foo()
    print("foo")
end

ClassSystem.Create(testClass, "testClass")

print("### END ###")
