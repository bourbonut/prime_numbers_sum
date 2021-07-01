cpdef unsigned long long P10(unsigned long long n):
    cdef unsigned long long r = int(n ** 0.5)
    assert r * r <= n and (r + 1) ** 2 > n
    cdef list V = [n // i for i in range(1, r + 1)]
    V += list(range(V[-1] - 1, 0, -1))
    cdef dict S = {i: i * (i + 1) // 2 - 1 for i in V}
    cdef int p
    cdef unsigned long long v, sp, p2
    for p in range(2, r + 1):
        sp = S[p - 1]
        if S[p] > sp:  # p is prime
            p2 = p * p
            for v in V:
                if v < p2:
                    break
                S[v] -= p * (S[v // p] - sp)
    return S[n]
