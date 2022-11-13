IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")

groups = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n\n", trim: true)
  |> Enum.map(fn g ->
    Enum.map(String.split(g, "\n"), fn p ->
      Enum.uniq(String.graphemes(p))
    end)
  end)

Enum.reduce(groups, 0, fn g, acc ->
  count = Enum.reduce(g, [], fn p, acc ->
    Enum.uniq(acc ++ p)
  end) |> Enum.count
  acc + count
end) |> IO.inspect

Enum.reduce(groups, 0, fn g, acc ->
  count = Enum.reduce(g, fn p, p_acc ->
    Enum.filter(p, fn c -> c in p_acc end)
  end) |> Enum.count
  acc + count
end) |> IO.inspect
