defmodule Solution do
  def part_one(comm, dist \\ 0, dep \\0)
  def part_one([], dist, dep), do: dist * dep
  def part_one([[:forward, n] | comm], dist, dep), do: part_one(comm, dist + n, dep)
  def part_one([[:down, n] | comm], dist, dep), do: part_one(comm, dist, dep + n)
  def part_one([[:up, n] | comm], dist, dep), do: part_one(comm, dist, dep - n)

  def part_two(comm, aim \\ 0, dist \\ 0, dep \\0)
  def part_two([], _, dist, dep), do: dist * dep
  def part_two([[:forward, n] | comm], aim, dist, dep), do: part_two(comm, aim, dist + n, dep + (aim * n))
  def part_two([[:down, n] | comm], aim, dist, dep), do: part_two(comm, aim + n, dist, dep)
  def part_two([[:up, n] | comm], aim, dist, dep), do: part_two(comm, aim - n, dist, dep)

  def run do
    input = __DIR__ <> "/" <> "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> String.split(line, " ", trim: true) end)
      |> Enum.map(fn [a, b] -> [String.to_atom(a), String.to_integer(b)] end)
    part_one(input) |> IO.inspect
    part_two(input) |> IO.inspect
  end
end

Solution.run
