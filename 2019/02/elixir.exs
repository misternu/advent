defmodule Day2 do

end

modules = __DIR__ <> "/" <> "input.txt"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  {integer, _leftover} = Integer.parse(line)
  integer
end)

# Day1.fuel(modules)
# |> IO.inspect

# Day1.fuel_and_extra(modules)
# |> IO.inspect