Code.require_file("helpers.exs", __DIR__ <> "/../lib")

passwords = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    String.split(line, ~r{\W+})
  end)

passwords
  |> Enum.count(fn [l, h, c, p] ->
      {low, _}  = Integer.parse(l)
      {high, _} = Integer.parse(h)
      count = String.graphemes(p)
        |> Enum.count(fn ch -> ch == c end)
      count >= low && count <= high
    end)
  |> IO.inspect

passwords
  |> Enum.count(fn [l, h, c, p] ->
      {low, _}  = Integer.parse(l)
      {high, _} = Integer.parse(h)
      (String.at(p, low - 1) == c) != (String.at(p, high - 1) == c)
    end)
  |> IO.inspect