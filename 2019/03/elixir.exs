defmodule Wire do
  # def get_crumbs("U", position, distance) do

  # end

  def get_crumbs("R", position, distance) do
    {x, y} = position
    Enum.map(1..distance, fn offset ->
      {x + offset, y}
    end)
  end

  # def get_crumbs("D", position, distance) do
  # end

  # def get_crumbs("L", position, distance) do
  # end

  def walk([], breadcrumbs, _position), do: breadcrumbs
  def walk([instruction | tail], breadcrumbs, position) do
    direction = String.at(instruction, 0)
    distance = String.slice(instruction, 1..-1)
      |> Integer.parse()
      |> elem(0)
    get_crumbs(direction, position, distance) |> List.last |> IO.inspect
  end

  def walk(instructions) do
    walk(instructions, [], {0,0})
  end 
end

[input1, input2] = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    String.split(line, ",", trim: true)
  end)

# Part 1
Wire.walk(input1)