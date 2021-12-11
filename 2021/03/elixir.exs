# Part 1: 3549854
# Part 2: 3765399

defmodule Solution do
  def part_one(input) do
    input
      |> Enum.map(&String.to_charlist/1)
      |> List.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(fn charlist -> Enum.frequencies(charlist)[49] > 500 end)
      |> Enum.map(fn one -> if one, do: ?1, else: ?0 end)
      |> List.to_integer(2)
      # "111111111111" == 4095
      |> (fn gamma -> gamma * (4095 - gamma) end).()
      |> IO.inspect
  end

  def count_ones(input, i) do
    fun = fn s -> (String.at(s, i) == "1") end
    Enum.count(input, fun)
  end

  def scrub(input, oxy \\ true, index \\ 0)
  def scrub([string], _, _), do: string |> String.to_integer(2)
  def scrub(input, type, i) do
    one = count_ones(input, i) >= Enum.count(input) / 2 == type
    char = if one, do: "1", else: "0"
    keep = Enum.filter(input, fn x -> String.at(x, i) == char end)
    scrub(keep, type, i + 1)
  end

  def part_two(input) do
    scrub(input) * scrub(input, false) |> IO.inspect
  end

  def run do
    input = __DIR__ <> "/" <> "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
    IO.puts("")
    part_one(input)
    part_two(input)
  end
end

Solution.run
