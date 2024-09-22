---@param func fun(num: integer?)
---@param amount integer
local function benchmark_function(func, amount)
    local startTime = os.clock()

    for i = 1, amount, 1 do
        func(i)
    end

    local endTime = os.clock()
    local totalTime = endTime - startTime

    print('total time: ' .. totalTime .. 's amount: ' .. amount)
    print('each time : ' .. (totalTime / amount) * 1000 * 1000 .. 'µs')
end

---@param func function
---@param amount integer
local function capture_function(func, amount)
    local startTime = os.clock()

    func()

    local endTime = os.clock()
    local totalTime = endTime - startTime

    print('total time: ' .. totalTime .. 's amount: ' .. amount)
    print('each time : ' .. (totalTime / amount) * 1000 * 1000 .. 'µs')
end

return { benchmark_function = benchmark_function, capture_function = capture_function }
