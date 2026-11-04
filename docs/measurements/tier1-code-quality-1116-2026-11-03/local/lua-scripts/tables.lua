local t = {}
for i = 1, 5000 do t[i] = (i * 7919) % 1000 end
table.sort(t, function(a, b) return a > b end)
print(t[1], t[2500], t[5000])
local m = {}
for i = 1, 3000 do m["k" .. i] = i end
local s = 0 for k, v in pairs(m) do s = s + v end
print(s, #t, table.concat({1, 2, 3, "x"}, ","))
local u = table.pack(table.unpack({1, nil, 3}, 1, 3))
print(u.n, u[1], u[2], u[3])
table.insert(t, 1, -1) table.remove(t) print(t[1], #t)
local mt = setmetatable({}, {__index = function(_, k) return k * 2 end, __call = function(self, x) return x + 1 end})
print(mt[21], mt(41), rawget(mt, 21))
