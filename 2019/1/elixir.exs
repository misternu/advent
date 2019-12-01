defmodule Day1 do
  def fuel(modules) do
    modules
    |> Enum.map(fn number -> (div number, 3) - 2 end)
    |> Enum.sum
  end

  def fuel_recursive(total, 0), do: total
  def fuel_recursive(total, module) do
    new_fuel = max((div module, 3) - 2, 0)
    fuel_recursive(total + new_fuel, new_fuel)
  end

  def fuel_and_extra(modules) do
    modules
    |> Enum.map(fn number -> fuel_recursive(0, number) end)
    |> Enum.sum
  end
end

modules = __DIR__ <> "/" <> "input.txt"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  {integer, _leftover} = Integer.parse(line)
  integer
end)

Day1.fuel(modules)
|> IO.inspect

Day1.fuel_and_extra(modules)
|> IO.inspect
