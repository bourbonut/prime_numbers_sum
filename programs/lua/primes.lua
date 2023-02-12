function P10(n)
    r = math.floor(n^0.5)
    assert(r * r <= n and (r + 1)^2 > n)
    V = {}
    for i = 1, r + 1, 1 do
        table.insert(V, n // i)
    end
    for i = V[#V] - 1, 1, -1 do
        table.insert(V, i)
    end
    S = {}
    for _, i in ipairs(V) do
        S[i] = i * (i + 1) // 2 - 1
    end
    for p = 2, r, 1 do
        if S[p] > S[p - 1] then
            sp = S[p - 1]
            p2 = p * p
            for _, v in ipairs(V) do
                if v < p2 then
                    break
                end
                S[v] = S[v] - p * (S[v // p] - sp)
            end
        end
    end
    return S[n]
end

function format(dist, value)
    return value .. string.rep(" ", (dist - string.len(value)))
end

print("Power | Time (µs) | Resultat")
print("========================================")
for i = 1, 8, 1 do
    start = os.clock()
    result = P10(math.floor(10^i))
    duration = math.floor((os.clock() - start) * 10^6)
    print(format(5, tostring(i)) .. " | " .. format(9, tostring(duration)) .. " | " .. tostring(result))
end
