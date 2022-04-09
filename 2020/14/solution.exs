IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")

lines = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

defmodule PartOne do
  def apply_mask(mask, number) do
    number_string = Integer.to_string(number,2) |> String.pad_leading(36, "0")
    Enum.map(0..36, fn i ->
      masked = String.at(mask, i)
      if masked != "X" do masked else String.at(number_string, i) end
    end) |> Enum.join |> String.to_integer(2)
  end

  def run(lines, mask \\ "", memory \\ %{})
  def run([], _, memory), do: memory |> Map.values |> Enum.sum
  def run([line | tail], mask, memory) do
    if Regex.match?(~r/mask/, line) do
      [_, new_mask] = Regex.run(~r/mask = ([01X]+)/, line)
      run(tail, new_mask, memory)
    else
      [_, addr, val_string] = Regex.run(~r/mem\[(\d+)\] = (\d+)/, line)
      key = String.to_integer(addr)
      val = apply_mask(mask, String.to_integer(val_string))
      new_memory = Map.merge(memory, %{ key => val })
      run(tail, mask, new_memory)
    end
  end
end

defmodule PartTwo do
  def apply_mask(mask, addr, output \\ [""])
  def apply_mask("", "", output), do: output
  def apply_mask(mask, addr, output) do
    case String.at(mask, 0) do
      "0" ->
        new_output = Enum.map(output, fn s -> s <> String.at(addr, 0) end)
        apply_mask(String.slice(mask, 1..-1), String.slice(addr, 1..-1), new_output)
      "1" -> 
        new_output = Enum.map(output, fn s -> s <> "1" end)
        apply_mask(String.slice(mask, 1..-1), String.slice(addr, 1..-1), new_output)
      _ -> 
        new_output = Enum.map(output, fn s -> s <> "0" end) ++ Enum.map(output, fn s -> s <> "1" end)
        apply_mask(String.slice(mask, 1..-1), String.slice(addr, 1..-1), new_output)
    end
  end

  def padded_binary(string) do
    string |> String.to_integer |> Integer.to_string(2) |> String.pad_leading(36, "0")
  end

  def run(lines, mask \\ "", memory \\ %{})
  def run([], _, memory), do: memory |> Map.values |> Enum.sum
  def run([line | tail], mask, memory) do
    if Regex.match?(~r/mask/, line) do
      [_, new_mask] = Regex.run(~r/mask = ([01X]+)/, line)
      run(tail, new_mask, memory)
    else
      [_, addr_string, val_string] = Regex.run(~r/mem\[(\d+)\] = (\d+)/, line)
      val = String.to_integer(val_string)
      paddr = padded_binary(addr_string)
      addrs = apply_mask(mask, paddr) |> Enum.map(fn s -> String.to_integer(s, 2) end)
      new_map = Enum.map(addrs, fn addr -> {addr, val} end) |> Enum.into(%{})
      new_memory = Map.merge(memory, new_map)
      run(tail, mask, new_memory)
    end
  end
end

PartOne.run(lines) |> IO.inspect
PartTwo.run(lines) |> IO.inspect
