defmodule Day1 do
  def fuel(modules) do
    modules
    |> Enum.map(fn line ->
      {integer, _leftover} = Integer.parse(line)
      integer
    end)
    |> Enum.map(fn number -> (div number, 3) - 2 end)
    |> Enum.sum
  end

  def fuel_recursive(total, 0) do
    total
  end

  def fuel_recursive(total, module) do
    new_fuel = max((div module, 3) - 2, 0)
    fuel_recursive(total + new_fuel, new_fuel)
  end

  def fuel_and_extra(modules) do
    modules
    |> Enum.map(fn line ->
      {integer, _leftover} = Integer.parse(line)
      integer
    end)
    |> Enum.map(fn number -> fuel_recursive(0, number) end)
    |> Enum.sum
  end
end

case System.argv do
  [input_file] ->
    __DIR__ <> "/" <> input_file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Day1.fuel()
    |> IO.inspect

    __DIR__ <> "/" <> input_file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Day1.fuel_and_extra()
    |> IO.inspect

  _ ->
    IO.puts :stderr, "use --test or file name"
    System.halt(1)
end