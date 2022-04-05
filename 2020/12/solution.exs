IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")

instructions = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

defmodule PartOne do
  def run(instructions, x \\ 0, y \\ 0, heading \\ 0)
  def run([], x, y, _), do: abs(x) + abs(y)
  def run([instruction | tail], x, y, heading) do
    [_, dir, num] = Regex.run(~r/(\w{1})(\d+)/, instruction)
    dist = String.to_integer(num)
    case dir do
      "N" ->
        run(tail, x, y + dist, heading)
      "S" ->
        run(tail, x, y - dist, heading)
      "E" ->
        run(tail, x + dist, y, heading)
      "W" ->
        run(tail, x - dist, y, heading)
      "L" ->
        run(tail, x, y, Integer.mod(heading - round(dist/90), 4))
      "R" ->
        run(tail, x, y, Integer.mod(heading + round(dist/90), 4))
      "F" ->
        case heading do
          0 ->
            run(tail, x + dist, y, heading)
          1 ->
            run(tail, x, y - dist, heading)
          2 ->
            run(tail, x - dist, y, heading)
          3 ->
            run(tail, x, y + dist, heading)
        end
    end
  end
end

defmodule PartTwo do
  def rotate_left(x, y, times)
  def rotate_left(x, y, 0), do: [x, y]
  def rotate_left(x, y, times) do
    rotate_left(-y, x, times - 1)
  end

  def rotate_right(x, y, times)
  def rotate_right(x, y, 0), do: [x, y]
  def rotate_right(x, y, times) do
    rotate_right(y, -x, times - 1)
  end

  def run(instructions, x \\ 0, y \\ 0, wx \\ 10, wy \\ 1)
  def run([], x, y, _, _), do: abs(x) + abs(y)
  def run([instruction | tail], x, y, wx, wy) do
    [_, dir, num] = Regex.run(~r/(\w{1})(\d+)/, instruction)
    dist = String.to_integer(num)
    case dir do
      # N/S are reversed from part one, so that our standard rotation equations above will work properly
      "N" ->
        run(tail, x, y, wx, wy + dist)
      "S" ->
        run(tail, x, y, wx, wy - dist)
      "E" ->
        run(tail, x, y, wx + dist, wy)
      "W" ->
        run(tail, x, y, wx - dist, wy)
      "F" ->
        run(tail, x + (wx * dist), y + (wy * dist), wx, wy)
      "L" ->
        [nx, ny] = rotate_left(wx, wy, round(dist/90))
        run(tail, x, y, nx, ny)
      "R" ->
        [nx, ny] = rotate_right(wx, wy, round(dist/90))
        run(tail, x, y, nx, ny)
    end
  end
end

PartOne.run(instructions) |> IO.inspect
PartTwo.run(instructions) |> IO.inspect
