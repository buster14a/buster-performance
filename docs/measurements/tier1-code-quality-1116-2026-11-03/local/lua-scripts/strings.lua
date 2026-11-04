local s = string.rep("abc", 1000, ",")
print(#s, s:sub(1, 11), s:find("c,a", 1, true), select(2, s:gsub("b", "B")))
print(("hello world"):upper(), ("%d items"):format(3), ("x=%g"):format(0.1), string.byte("A"), string.char(72, 105))
local words = {} for w in ("the quick brown fox jumps over the lazy dog"):gmatch("%a+") do words[#words + 1] = w end
print(#words, table.concat(words, "|"))
print(string.format("%-10s|%10s|", "left", "right"), tostring(1e15), tostring(2^63), math.tointeger(3.0), 10 / 3)
print(string.pack and #string.pack("i4i8", 1, 2), utf8 and utf8.char(72, 228, 8364), ("%5.1f"):format(-2.25))
