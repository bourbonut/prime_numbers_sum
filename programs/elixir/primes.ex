defmodule Primes do
  @spec sqrt(integer) :: integer
  defp sqrt(n) do
    trunc(:math.sqrt(n))
  end

  @spec head_keys(integer, integer) :: [integer]
  defp head_keys(n, root_n) do
    1..(root_n + 1)
    |> Enum.map(&div(n, &1))
  end

  @spec tail_keys(integer, integer) :: [integer]
  defp tail_keys(n, root_n) do
    Enum.to_list(div(n, root_n)..1)
  end

  @spec generate_keys(integer, integer) :: [integer]
  defp generate_keys(n, root_n) do
    head_keys(n, root_n) ++ tail_keys(n, root_n)
  end

  @spec n_sums(integer) :: {integer}
  defp n_sums(i) do
    {i, div(i * (i + 1), 2) - 1}
  end

  @spec generate_sums([integer]) :: %{integer => integer}
  defp generate_sums(keys) do
    Enum.into(keys, %{}, &n_sums(&1))
  end

  @spec small(integer, %{integer => integer}, integer, integer) :: {integer}
  defp small(v, dict, p, sp) do
    {v, dict[v] - p * (dict[div(v, p)] - sp)}
  end

  @spec calculate(%{integer => integer}, [integer], integer, integer) :: %{integer => integer}
  defp calculate(sums, keys, p, limit) when p < limit do
    sum_p = sums[p - 1]

    if sums[p] > sum_p do
      Enum.take_while(keys, &(&1 >= p * p))
      |> Enum.into(%{}, &small(&1, sums, p, sum_p))
      |> (&Map.merge(sums, &1)).()
      |> calculate(keys, p + 1, limit)
    else
      calculate(sums, keys, p + 1, limit)
    end
  end

  @spec calculate(%{integer => integer}, [integer], integer, integer) :: %{integer => integer}
  defp calculate(sums, _, p, limit) when p >= limit do
    sums
  end

  @spec sum_up_to(integer) :: integer
  def sum_up_to(n) do
    root_n = sqrt(n)
    keys = generate_keys(n, root_n)
    sums = generate_sums(keys)
    calculate(sums, keys, 2, root_n + 1)[n]
  end

  @spec measure(function) :: integer
  def measure(function) do
    function
    |> :timer.tc()
    |> elem(0)
    # divide by 1_000 for milliseconds
    |> Kernel./(1)
  end
end

defmodule Formatter do
  @spec add_space(integer, charlist) :: charlist
  defp add_space(0, string) do
    string
  end

  @spec add_space(integer, charlist) :: charlist
  defp add_space(i, string) do
    add_space(i - 1, string <> " ")
  end

  @spec format(integer, integer) :: charlist
  defp format(dist, value) do
    string_v = "#{value}"
    add_space(dist - String.length(string_v), string_v)
  end

  @spec format_all(integer, integer, integer) :: nil
  def format_all(power, time, value) do
    IO.puts("#{format(5, power)} | #{format(9, time)} | #{value}")
  end
end

IO.puts("Power | Time (µs) | Result")
IO.puts("=========================================")

Primes.sum_up_to(100)

1..8
|> Enum.map(fn exp ->
  f = Primes.measure(fn -> Primes.sum_up_to(:math.pow(10, exp) |> round) end)
  Formatter.format_all(exp, f |> round, Primes.sum_up_to(:math.pow(10, exp) |> round))
end)
