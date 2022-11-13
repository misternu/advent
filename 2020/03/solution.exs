defmodule Solution do
  def tree([head | _], position) do
    if String.at(head, position) == "#", do: 1, else: 0
  end

  def width([head | _]) do
    String.length(head)
  end

  def ski(lines, vector, position \\ 0, acc \\ 0)
  def ski([], _, _, acc), do: acc
  def ski(lines, {down, right}, position, acc) do
    ski(
      Enum.slice(lines, down..-1),
      {down, right},
      rem(position + right, width(lines)),
      acc + tree(lines, position)
    )
  end

  def run do
    lines = __DIR__ <> "/" <> "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)

    ski(lines, {1, 3}) |> IO.puts

    vectors = [{1,1}, {1,3}, {1,5}, {1,7}, {2,1}]
    Enum.map(vectors, fn vector -> ski(lines, vector) end)
      |> Enum.reduce(fn x, acc -> x * acc end)
      |> IO.inspect
  end
end

IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")
Solution.run
