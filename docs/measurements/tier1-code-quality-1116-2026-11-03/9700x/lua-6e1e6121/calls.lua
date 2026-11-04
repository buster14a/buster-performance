-- Recursive calls and integer additions: the interpreter's call path.
local function fib(n)
    if n < 2 then
        return n
    end
    return fib(n - 1) + fib(n - 2)
end
local total = 0
for i = 1, 3 do
    total = total + fib(27)
end
print("calls", total)
