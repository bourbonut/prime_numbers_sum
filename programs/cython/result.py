from cprimes import P10
from time import perf_counter


def _format(dist, value):
    return value + " " * (dist - len(value))


print("Power | Time (µs) | Result")
print("========================================")
for i in range(1, 9):
    start = perf_counter()
    result = P10(10 ** i)
    duration = int((perf_counter() - start) * 1_000_000)
    print(_format(5, str(i)) + " | " + _format(9, str(duration)) + " | " + str(result))
