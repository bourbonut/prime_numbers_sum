# Sum of prime numbers with multiple languages

## Description

The project allows to see the difference of speed of program's execution between multiple languages with one algorithm which calculates the sum of prime numbers.
Also, the goal is to use native libraries for each language.

Languages:
* C++
* Cython
* Elexir
* Python
* Rust

## Algorithm used

```python
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
```

Here is the [source of the algorithm](https://stackoverflow.com/questions/4057527/need-help-optimizing-algorithm-sum-of-all-prime-numbers-under-two-million)

## Result

![](graph.svg)

## Limits

With low level languages such as C++ or Cython, it's hard too manage high numbers without bringing an external library.
In Rust, I don't have this problem, there are integers with 128 bits.
But for instance, with C++, there are some issues when I try to manipulate integers with 128 bits.
A solution could be to store numbers into string and manipulate them. But I think it will drastically slow down the speed of program's execution.

## Possible improvements

Elixir is a new functional programming language. There is almost no help you can find on the Internet to improve your code.
I'm a beginner with Elixir and I think there are some improvements that could be done to improve the speed of program's execution.

## Notes

The idea comes from the challenge Euler problem n°245 where there is a sum of prime numbers up to 10e11.
