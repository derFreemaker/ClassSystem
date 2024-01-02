local argparse = require("tools.argparse")
local fs = require("tools.fs")
local utils = require("tools.utils")

local CurrentDirectory = fs.Path(fs.GetCurrentDirectory())
local RootDirectory = CurrentDirectory:Extend(".."):Normalize()
local CurrentWorkingDirectory = fs.Path(fs.GetCurrentWorkingDirectory())

local parser = argparse("bundle", "Used to bundle a file together by importing the files it uses with require")
parser:argument("input", "Input file.")
parser:option("-o --output", "Output file.", "out.lua")

---@type { input: string, output: string }
local args = parser:parse()
-- //TODO: remove debug args

local InputFilePath = fs.Path(args.input)
if InputFilePath:IsRelative() then
    InputFilePath = CurrentWorkingDirectory:Extend(InputFilePath:ToString())
end

local OutputFilePath = fs.Path(args.output)
if OutputFilePath:IsRelative() then
    OutputFilePath = CurrentWorkingDirectory:Extend(OutputFilePath:ToString())
end

local outFile = io.open(OutputFilePath:ToString(), "w+")
if not outFile then
    error("unable to open output: " .. args.output)
end

-- Head
----------------------------------------------------------------

outFile:write([[local __fileFuncs__ = {}
local __cache__ = {}
local function __loadFile__(module)
    if not __cache__[module] then
        __cache__[module] = { __fileFuncs__[module]() }
    end
    return table.unpack(__cache__[module])
end

]])

----------------------------------------------------------------

---@class Freemaker.Bundle.require
---@field module string
---@field startPos integer
---@field endPos integer
---@field replace boolean

local bundler = {}

---@param text string
---@return Freemaker.Bundle.require[]
function bundler.findAllRequires(text)
    ---@type Freemaker.Bundle.require[]
    local requires = {}
    local currentPos = 0
    while true do
        local startPos, endPos, match = text:find('require%("([^"]+)"%)', currentPos)
        if startPos == nil then
            startPos, endPos, match = text:find('require% "([^"]+)"', currentPos)
        end

        if startPos == nil then
            break
        end

        ---@type Freemaker.Bundle.require
        ---@diagnostic disable-next-line: assign-type-mismatch
        local require = { module = match, startPos = startPos, endPos = endPos, replace = true }

        table.insert(requires, require)
        ---@diagnostic disable-next-line: cast-local-type
        currentPos = endPos
    end
    return requires
end

---@param requires Freemaker.Bundle.require[]
---@param text string
---@return string text
function bundler.replaceRequires(requires, text)
    local diff = 0
    for _, require in pairs(requires) do
        if not require.replace then
            goto continue
        end

        local front = text:sub(0, require.startPos + diff - 1)
        local back = text:sub(require.endPos + diff + 1)
        text = front .. "__loadFile__(\"" .. require.module .. "\")" .. back
        diff = diff + 5

        ::continue::
    end

    return text
end

local cache = {}

---@param requires Freemaker.Bundle.require[]
function bundler.processRequires(requires)
    for _, require in pairs(requires) do
        ---@type string[]
        local records = {}
        local requirePath = RootDirectory:Extend(require.module:gsub("%.", "\\") .. ".lua")
        if not requirePath:Exists() then
            table.insert(records, requirePath:ToString())
            requirePath = RootDirectory:Extend(require.module:gsub("%.", "\\") .. "\\init.lua")
            if not requirePath:Exists() then
                table.insert(records, requirePath:ToString())
                print("WARNING: unable to find: " .. require.module
                    .. " with paths: \"" .. utils.JoinStr(records, "\";\"") .. "\"")
                require.replace = false
                goto continue
            end
        end

        bundler.processFile(requirePath, require.module)
        ::continue::
    end
end

---@param path Tools.FileSystem.Path
---@param module string
function bundler.processFile(path, module)
    if cache[module] then
        return cache[module]
    end

    local file = io.open(path:ToString())
    if not file then
        error("unable to open: " .. path:ToString())
    end
    local text = file:read("a")
    file:close()

    local requires = bundler.findAllRequires(text)
    bundler.processRequires(requires)

    text = bundler.replaceRequires(requires, text)
    cache[module] = text

    outFile:write("__fileFuncs__[\"" .. module .. "\"] = function()\n")
    local lines = utils.SplitStr(text, "\n", false)
    for _, line in pairs(lines) do
        if line ~= "" then
            outFile:write("    " .. line .. "\n")
        end
    end
    outFile:write("end\n\n")
end

bundler.processFile(InputFilePath, "__main__")

outFile:write("return __loadFile__(\"" .. "__main__" .. "\")")

print("done!")
