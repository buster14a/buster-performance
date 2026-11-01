-- Strings: formatting, concatenation through a buffer, patterns and substitution.
local parts = {}
for i = 1, 40000 do
    parts[#parts + 1] = string.format("%d:%x:%.3f;", i, i * 7, i / 13)
end
local text = table.concat(parts)
local words = 0
for _ in text:gmatch("%d+:") do
    words = words + 1
end
local replaced, count = text:gsub("(%d)(%d)", "%2%1")
local upper = text:upper()
local found = 0
local position = 1
while true do
    local first = upper:find("A", position, true)
    if not first then
        break
    end
    found = found + 1
    position = first + 1
end
print("strings", #text, words, count, #replaced, found)
