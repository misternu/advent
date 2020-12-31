defmodule Solution do
  def run do
    groups = __DIR__ <> "/" <> "input.txt"
      |> File.read!()
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn g ->
        Enum.map(String.split(g, "\n"), fn p ->
          Enum.uniq(String.graphemes(p))
        end)
      end)

    Enum.reduce(groups, 0, fn g, acc ->
      count = Enum.reduce(g, [], fn p, acc -> Enum.uniq(acc ++ p) end) |> Enum.count
      acc + count
    end) |> IO.inspect

    Enum.reduce(groups, 0, fn g, acc ->
      count = Enum.reduce(g, fn p, p_acc ->
        Enum.reduce(p, [], fn c, c_acc ->
          if c in p_acc, do: [c | c_acc], else: c_acc
        end)
      end) |> Enum.count
      acc + count
    end) |> IO.inspect
  end
end

IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")
Solution.run