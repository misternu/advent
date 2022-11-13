defmodule Wire do
  def add_crumb(crumbs, k, v), do: Map.get(crumbs, k) && crumbs || Map.put(crumbs, k, v)

  def crumbs(br, "U", {x, y}, d, s) do
    Enum.reduce(1..d, br, fn o, a -> add_crumb(a, {x, y + o}, s + o) end)
  end

  def crumbs(br, "R", {x, y}, d, s) do
    Enum.reduce(1..d, br, fn o, a -> add_crumb(a, {x + o, y}, s + o) end)
  end

  def crumbs(br, "D", {x, y}, d, s) do
    Enum.reduce(1..d, br, fn o, a -> add_crumb(a, {x, y - o}, s + o) end)
  end

  def crumbs(br, "L", {x, y}, d, s) do
    Enum.reduce(1..d, br, fn o, a -> add_crumb(a, {x - o, y}, s + o) end)
  end

  def walk([], breadcrumbs, _position, _steps), do: breadcrumbs
  def walk([instruction | tail], breadcrumbs, position, steps) do
    direction = String.at(instruction, 0)
    distance = String.slice(instruction, 1..-1)
      |> Integer.parse()
      |> elem(0)
    new_crumbs = crumbs(breadcrumbs, direction, position, distance, steps)
    {new_position, new_steps} = Map.to_list(new_crumbs) |> Enum.max_by(fn {_p, s} -> s end)
    walk(tail, Map.merge(new_crumbs, breadcrumbs), new_position, new_steps)
  end

  def walk(instructions) do
    walk(instructions, %{}, {0,0}, 0)
  end 
end

[input1, input2] = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    String.split(line, ",", trim: true)
  end)

[wire1, wire2] = [Wire.walk(input1), Wire.walk(input2)]
# Part 1
[wire1points, wire2points] = [Map.keys(wire1), Map.keys(wire2)]
overlap = wire1points -- (wire1points -- wire2points)
overlap
  |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
  |> Enum.min
  |> IO.puts

# Part 2
Enum.map(overlap, fn i ->
  Map.get(wire1, i) + Map.get(wire2, i)
end)
  |> Enum.min |> IO.puts
