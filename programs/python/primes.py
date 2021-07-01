import math
from time import perf_counter


def chrono(function):
    def inner(*args):
        start = perf_counter()
        result = function(*args)
        duration = perf_counter() - start
        print("%0.3f x 10e(-3) seconds" % (duration * 1_000))
        return result

    return inner


# @chrono
def P10(n):
    r = int(n ** 0.5)
    assert r * r <= n and (r + 1) ** 2 > n
    V = [n // i for i in range(1, r + 1)]
    V += list(range(V[-1] - 1, 0, -1))
    S = {i: i * (i + 1) // 2 - 1 for i in V}
    for p in range(2, r + 1):
        if S[p] > S[p - 1]:  # p is prime
            sp = S[p - 1]  # sum of primes smaller than p
            p2 = p * p
            for v in V:
                if v < p2:
                    break
                S[v] -= p * (S[v // p] - sp)
    return S[n]


def _format(dist, value):
    return value + " " * (dist - len(value))


print("Power | Time (µs) | Resultat")
print("========================================")
for i in range(1, 9):
    start = perf_counter()
    result = P10(10 ** i)
    duration = int((perf_counter() - start) * 1_000_000)
    print(_format(5, str(i)) + " | " + _format(9, str(duration)) + " | " + str(result))
