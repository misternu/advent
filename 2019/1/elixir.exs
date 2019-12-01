defmodule Day1 do
  def fuel(modules) do
    modules
    |> Enum.map(fn number -> (div number, 3) - 2 end)
    |> Enum.sum
  end

  def fuel_recursive(module) when module < 9, do: 0
  def fuel_recursive(module) do
    # body recursion turned out to be faster
    new_fuel = (div module, 3) - 2
    new_fuel + fuel_recursive(new_fuel)
  end

  def fuel_and_extra(modules) do
    modules
    |> Enum.map(fn number -> fuel_recursive(number) end)
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
