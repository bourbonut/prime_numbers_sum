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

  @spec set(integer, %{integer => integer}, integer, integer) :: {integer}
  defp set(v, dict, p, sp) do
    {v, dict[v] - p * (dict[div(v, p)] - sp)}
  end

  @spec calculate(integer, %{integer => integer}, [integer]) :: %{integer => integer}
  defp calculate(2, sums, keys) do
    update(2, sums, keys)
  end

  @spec calculate(integer, %{integer => integer}, [integer]) :: %{integer => integer}
  defp calculate(i, sums, keys) do
    update(i, calculate(i - 1, sums, keys), keys)
  end

  @spec calculate(integer, %{integer => integer}, [integer]) :: %{integer => integer}
  defp update(p, sums, keys) do
    sum_p = sums[p - 1]

    if sums[p] > sum_p do
      p_square = p * p

      Enum.take_while(keys, &(&1 >= p_square))
      |> Enum.into(sums, &set(&1, sums, p, sum_p))
    else
      sums
    end
  end

  @spec sum_up_to(integer) :: integer
  def sum_up_to(n) do
    root_n = sqrt(n)
    keys = generate_keys(n, root_n)
    sums = generate_sums(keys)

    calculate(root_n + 1, sums, keys)[n]
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

1..8
|> Enum.map(fn exp ->
  f = Primes.measure(fn -> Primes.sum_up_to(:math.pow(10, exp) |> round) end)
  Formatter.format_all(exp, f |> round, Primes.sum_up_to(:math.pow(10, exp) |> round))
end)
