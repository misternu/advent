IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")

chars = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.graphemes(&1))

height = Enum.count(chars)
width = Enum.count(List.first(chars))

seat_map = Enum.with_index(chars)
  |> Enum.reduce(%{}, fn {row, y}, acc ->
    row_map = Enum.with_index(row)
      |> Enum.reduce(%{}, fn {char, x}, acc ->
        Map.put(acc, y * width + x,  char)
      end)
    Map.merge(acc, row_map)
  end)

neighbors = Enum.reduce(0..(height-1), %{}, fn y, acc ->
  row_neighbors = Enum.reduce(0..(width-1), %{}, fn x, acc ->
    neighbor_coords =

  end)
end)
