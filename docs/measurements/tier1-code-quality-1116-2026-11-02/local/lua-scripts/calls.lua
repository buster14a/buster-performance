local function fib(n) if n < 2 then return n end return fib(n-1) + fib(n-2) end
local function va(...) local s = 0 for i = 1, select('#', ...) do s = s + (select(i, ...)) end return s, select('#', ...) end
local t = {}
for i = 1, 200 do t[i] = va(i, i*2, i*3) end
print(fib(24), va(1,2,3,4,5), #t, t[200])
local ok, err = pcall(function() error({code=42}) end)
print(ok, type(err), err.code)
print(select(2, pcall(error, "msg", 0)))
local co = coroutine.wrap(function(a) local b = coroutine.yield(a+1) local c = coroutine.yield(b*2) return c - 1 end)
print(co(1), co(10), co(100))
print(string.format("%d %5.2f %s %x %q", 12345, 3.14159, "str", 255, "a\nb"))
print(math.maxinteger, math.mininteger, math.maxinteger + 1 == math.mininteger, 7 // 2, -7 // 2, 7 % -3, -7 % 3, 7.5 // 2)
print(1 << 62, 3 & 5, 3 | 5, 3 ~ 5, ~0, 1 >> 1, -1 >> 60)
