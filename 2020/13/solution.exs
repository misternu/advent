IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")

lines = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

[timestamp, busses] = lines
timestamp = String.to_integer(timestamp)
part_one_busses = String.split(busses, ",", trim: true)
  |> Enum.filter(fn s -> s != "x" end)
  |> Enum.map(&String.to_integer/1)

part_two_busses = String.split(busses, ",", trim: true)
  |> Enum.with_index
  |> Enum.filter(fn {v, _} -> v != "x" end)
  |> Enum.map(fn {v, i} -> {String.to_integer(v), i} end)

defmodule PartOne do
  def run(timestamp, busses) do
    times = Enum.map(busses, fn bus ->
      if rem(timestamp, bus) == 0 do
        timestamp
      else
        { bus, bus * (div(timestamp, bus) + 1) }
      end
    end)
    {id, time} = Enum.min_by(times, fn {_, time} -> time end)
    difference = time - timestamp
    difference * id
  end
end

defmodule PartTwo do
  def run(busses, product \\ 0, total \\ 0, coefficient \\ 0)
  def run([], _, total, _), do: total
  def run([{bus, _} | tail], 0, 0, 0), do: run(tail, bus, bus, 0)
  def run([{b, i} | tail], p, t, c) when rem(t + p * c + i, b) == 0, do: run(tail, p * b, t + p * c, 0)
  def run([{bus, index} | tail], product, total, coefficient) do
    run([{bus, index} | tail], product, total, coefficient + 1)
  end
end


PartOne.run(timestamp, part_one_busses) |> IO.inspect
PartTwo.run(part_two_busses) |> IO.inspect
