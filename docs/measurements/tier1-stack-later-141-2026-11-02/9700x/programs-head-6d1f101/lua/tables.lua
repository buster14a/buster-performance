-- Arrays and hash tables: a sieve, a sort with a comparator, and string keys.
local limit = 400000
local composite = {}
for i = 2, limit do
    composite[i] = false
end
for i = 2, limit do
    if not composite[i] then
        for j = i * i, limit, i do
            composite[j] = true
        end
    end
end
local primes = 0
for i = 2, limit do
    if not composite[i] then
        primes = primes + 1
    end
end
local values = {}
local seed = 12345
for i = 1, 60000 do
    seed = (seed * 1103515245 + 12345) % 2147483648
    values[i] = seed
end
table.sort(values, function(a, b) return a > b end)
local counts = {}
for i = 1, 60000 do
    local key = "k" .. (values[i] % 997)
    counts[key] = (counts[key] or 0) + 1
end
local distinct = 0
for _ in pairs(counts) do
    distinct = distinct + 1
end
print("tables", primes, values[1], values[60000], distinct)
