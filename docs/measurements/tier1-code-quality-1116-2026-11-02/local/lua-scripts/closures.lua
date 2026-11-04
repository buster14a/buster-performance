local function counter() local c = 0 return function() c = c + 1 return c end end
local cs = {} for i = 1, 100 do cs[i] = counter() end
local total = 0 for r = 1, 50 do for i = 1, 100 do total = total + cs[i]() end end
print(total)
local function compose(f, g) return function(...) return f(g(...)) end end
local inc = function(x) return x + 1 end local dbl = function(x) return x * 2 end
local h = compose(inc, compose(dbl, inc))
local acc = 0 for i = 1, 10000 do acc = acc + h(i) end
print(acc)
goto skip
print("not printed")
::skip::
local x = 0 for i = 10, 1, -3 do x = x * 10 + i end print(x)
local f = 0.0 for i = 1, 1000 do f = f + 1 / i end print(string.format("%.10f", f))
