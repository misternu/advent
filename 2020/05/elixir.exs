defmodule Solution do
  def id(string) do
    Enum.map(String.graphemes(string), fn char ->
      if char in ["B", "R"], do: "1", else: "0"
    end) |> Enum.join
  end

  def run do
    ids = __DIR__ <> "/" <> "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn string -> id(string) end)
      |> Enum.map(fn bin -> {int, _} = Integer.parse(bin, 2); int end)

    IO.inspect(Enum.max(ids))

    total = Enum.reduce(Enum.min(ids)..Enum.max(ids), fn x, acc -> x + acc end)
    listed = Enum.reduce(ids, fn x, acc -> x + acc end)
    IO.inspect(total - listed)
  end
end

IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")
Solution.run