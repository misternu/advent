IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")

numbers = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    {integer, _leftover} = Integer.parse(line)
    integer
  end)

defmodule CombinationHelper do
  def combinations(list, num)
  def combinations(_, 0), do: [[]]
  def combinations([], _), do: []
  def combinations([head | tail], num) do
    Enum.map(combinations(tail, num - 1), &[head | &1]) ++
      combinations(tail, num)
  end
end

defmodule SumBuilder do
  def build(list, index)
  def build(_, index) when index < 25, do: false
  def build(list, index) do
    CombinationHelper.combinations(Enum.slice(list, (index-25)..(index-1)), 2)
      |> Enum.map(fn pair -> Enum.sum(pair) end)
  end
end

defmodule PartOne do
  def run(numbers) do
    sums = SumBuilder.build(numbers, 25)
    number = Enum.at(numbers, 25)
    if Enum.all?(sums, fn sum -> sum != number end) do
      number
    else
      [_ | tail] = numbers
      run(tail)
    end
  end
end

defmodule PartTwo do
  def run(numbers, target) do
    parts = Enum.reduce_while(numbers, [], fn n, acc ->
      if Enum.sum(acc) < target, do: {:cont, acc ++ [n] }, else: {:halt, acc}
    end)
    if Enum.sum(parts) == target do
      Enum.min(parts) + Enum.max(parts)
    else
      [_ | tail] = numbers
      run(tail, target)
    end
  end
end

part_one = PartOne.run(numbers)
IO.inspect(part_one)
PartTwo.run(numbers, part_one) |> IO.inspect
