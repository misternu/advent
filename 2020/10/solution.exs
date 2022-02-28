IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")

numbers = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    {integer, _leftover} = Integer.parse(line)
    integer
  end)
  |> Enum.sort


defmodule PartOne do
  def run(numbers, jumps \\ %{ 1 => 1, 2 => 0, 3 => 1 })
  def run(numbers, jumps) when length(numbers) < 2, do: jumps[1] * jumps[3]
  def run(numbers, jumps) do
    [head | tail] = numbers
    jump = List.first(tail) - head
    new_jumps = Map.merge(jumps, %{ jump => jumps[jump] + 1 })
    run(tail, new_jumps)
  end
end

defmodule PartTwo do
  def groups(numbers, groups \\ [1], last \\ 0)
  def groups([], groups, _), do: groups
  def groups(numbers, groups, last) do
    [head | tail] = numbers
    if head - last == 1 do
      [group | group_tail] = groups
      groups(tail, [group + 1 | group_tail], head)
    else
      groups(tail, [1 | groups], head)
    end
  end

  def run(numbers) do
    # worked out separately in rewrite.rb how many ways you can get through groups of numbers of these 5 sizes
    group_sizes = %{1=>1, 2=>1, 3=>2, 4=>4, 5=>7}
    Enum.reduce(groups(numbers), fn n, acc -> group_sizes[n] * acc end)
  end
end

part_one = PartOne.run(numbers)
part_two = PartTwo.run(numbers)

IO.inspect(part_one)
IO.inspect(part_two)
