IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")

input = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split(",", trim: true)
  |> Enum.map(fn s -> String.to_integer(s) end)
  |> Enum.with_index
  |> Enum.into(%{})

defmodule PartOne do
  def run(_, number, 2019), do: number
  def run(memory, number, index) do
    if Map.has_key?(memory, number) do
      run(Map.merge(memory, %{number => index}), index - memory[number], index + 1)
    else
      run(Map.merge(memory, %{number => index}), 0, index + 1)
    end
  end
end

defmodule PartTwo do
  def run(_, number, 29999999), do: number
  def run(memory, number, index) do
    if Map.has_key?(memory, number) do
      run(Map.merge(memory, %{number => index}), index - memory[number], index + 1)
    else
      run(Map.merge(memory, %{number => index}), 0, index + 1)
    end
  end
end

PartOne.run(input, 0, 7) |> IO.inspect
PartTwo.run(input, 0, 7) |> IO.inspect
