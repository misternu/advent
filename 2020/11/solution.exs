IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")

chars = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.graphemes(&1))

directions = [{0,-1}, {1,-1}, {1,0}, {1,1}, {0,1}, {-1,1}, {-1,0}, {-1,-1}]

height = Enum.count(chars)
width = Enum.count(List.first(chars))

seat_map = Enum.with_index(chars)
  |> Enum.reduce(%{}, fn {row, y}, acc ->
    row_map = Enum.with_index(row)
      |> Enum.filter(fn {char, _} -> char == "L" end)
      |> Enum.reduce(%{}, fn {_, x}, acc ->
        Map.put(acc, y * width + x, :L)
      end)
    Map.merge(acc, row_map)
  end)

neighbors = Enum.reduce(0..(height-1), %{}, fn y, acc ->
  row_neighbors = Enum.reduce(0..(width-1), %{}, fn x, acc ->
    pos_neighbors = Enum.map(directions, fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.filter(fn {x, y} -> x >= 0 && y >= 0 && x < width && y < height end)
      |> Enum.map(fn {x, y} -> y * width + x end) 
    Map.put(acc, y * width + x, pos_neighbors)
  end)
  Map.merge(acc, row_neighbors)
end)

defmodule LineOfSight do
  def look(seat_map, dx, dy, x, y, width, height)
  def look(_, dx, _, x, _, _, _)      when dx + x < 0, do: nil
  def look(_, dx, _, x, _, width, _)  when dx + x >= width, do: nil
  def look(_, _, dy, _, y, _, _)      when dy + y < 0, do: nil
  def look(_, _, dy, _, y, _, height) when dy + y >= height, do: nil
  def look(seat_map, dx, dy, x, y, width, height) do
    nx = dx + x
    ny = dy + y
    if seat_map[ny * width + nx] == :L do
      {nx, ny}
    else
      look(seat_map, dx, dy, nx, ny, width, height)
    end
  end
end

distant_neighbors = Enum.reduce(0..(height-1), %{}, fn y, acc ->
  row_neighbors = Enum.reduce(0..(width-1), %{}, fn x, acc ->
    pos_neighbors = Enum.map(directions, fn {dx, dy} ->
      LineOfSight.look(seat_map, dx, dy, x, y, width, height) end)
      |> Enum.filter(& &1)
      |> Enum.map(fn {x, y} -> y * width + x end) 
    Map.put(acc, y * width + x, pos_neighbors)
  end)
  Map.merge(acc, row_neighbors)
end)

defmodule DayEleven do
  def run(neighbors, seat_map, threshold \\ 4) do
    new_seat_map = Enum.reduce(Map.keys(seat_map), %{}, fn key, acc ->
      if seat_map[key] == :L do
        any = Enum.any?(neighbors[key], fn n_key -> seat_map[n_key] == :T end)
        Map.put(acc, key, if any do :L else :T end)
      else
        count = Enum.count(neighbors[key], fn n_key -> seat_map[n_key] == :T end)
        Map.put(acc, key, if count >= threshold do :L else :T end)
      end
    end)
    
    if new_seat_map === seat_map do
      seat_map |> Map.values |> Enum.count(fn v -> v == :T end)
    else
      run(neighbors, new_seat_map, threshold)
    end
  end
end

DayEleven.run(neighbors, seat_map) |> IO.inspect
DayEleven.run(distant_neighbors, seat_map, 5) |> IO.inspect
