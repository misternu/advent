defmodule Solution do
  def part_one(left, right) do
    Enum.zip(Enum.sort(left), Enum.sort(right))
      |> Enum.map(fn {a, b} -> abs(a - b) end)
      |> Enum.sum
      |> IO.inspect
  end

  def part_two(left, right) do
    Enum.map(left, fn a -> Enum.count(right, fn b -> a == b end) * a end)
      |> Enum.sum
      |> IO.inspect
  end

  def run do
    [left, right] = __DIR__ <> "/" <> "input.txt"
      |> File.read!()
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn s -> Enum.map(String.split(s, "   "), &String.to_integer/1) end)
      |> Enum.zip_with(&Function.identity/1)
    part_one(left, right)
    part_two(left, right)
  end
end

IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")
Solution.run
