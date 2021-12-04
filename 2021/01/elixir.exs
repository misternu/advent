IEx.Helpers.clear

input = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    {integer, _leftover} = Integer.parse(line)
    integer
  end)

input
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.count(fn [a, b] -> a < b end)
  |> IO.inspect

input
  |> Enum.chunk_every(4, 1, :discard)
  |> Enum.count(fn [a, b, c, d] -> a < d end)
  |> IO.inspect
