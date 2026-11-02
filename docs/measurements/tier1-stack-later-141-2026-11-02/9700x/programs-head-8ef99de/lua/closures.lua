-- Closures, coroutines and objects through metatables.
local Point = {}
Point.__index = Point
function Point.new(x, y)
    return setmetatable({x = x, y = y}, Point)
end
function Point.__add(a, b)
    return Point.new(a.x + b.x, a.y + b.y)
end
function Point:length2()
    return self.x * self.x + self.y * self.y
end
local sum = Point.new(0, 0)
for i = 1, 200000 do
    sum = sum + Point.new(i % 7, i % 11)
end
local function counter()
    local n = 0
    return function()
        n = n + 1
        return n
    end
end
local next_value = counter()
local acc = 0
for _ = 1, 300000 do
    acc = acc + next_value()
end
local producer = coroutine.wrap(function()
    for i = 1, 100000 do
        coroutine.yield(i)
    end
end)
local yielded = 0
for _ = 1, 100000 do
    yielded = yielded + producer()
end
print("closures", sum.x, sum.y, sum:length2(), acc, yielded)
