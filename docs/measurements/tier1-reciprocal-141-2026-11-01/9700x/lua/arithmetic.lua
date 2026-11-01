-- Integer and floating arithmetic: digit sums by // and %, and a Mandelbrot set.
local digits = 0
for n = 1, 600000 do
    local m = n
    while m > 0 do
        digits = digits + m % 10
        m = m // 10
    end
end
local inside = 0
local size = 160
for y = 0, size - 1 do
    local ci = 2.0 * y / size - 1.0
    for x = 0, size - 1 do
        local cr = 2.0 * x / size - 1.5
        local zr, zi = 0.0, 0.0
        local escaped = false
        for _ = 1, 50 do
            local zr2, zi2 = zr * zr, zi * zi
            if zr2 + zi2 > 4.0 then
                escaped = true
                break
            end
            zi = 2.0 * zr * zi + ci
            zr = zr2 - zi2 + cr
        end
        if not escaped then
            inside = inside + 1
        end
    end
end
print("arithmetic", digits, inside)
