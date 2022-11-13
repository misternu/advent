Code.require_file("helpers.exs", __DIR__ <> "/../lib")

entries = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    {integer, _leftover} = Integer.parse(line)
    integer
  end)

entries
  |> Helpers.combinations(2)
  |> Enum.find(fn x -> Enum.sum(x) == 2020 end)
  |> Enum.reduce(fn x, acc -> x * acc end)
  |> IO.inspect

entries
  |> Helpers.combinations(3)
  |> Enum.find(fn x -> Enum.sum(x) == 2020 end)
  |> Enum.reduce(fn x, acc -> x * acc end)
  |> IO.inspect