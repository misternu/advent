IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")

instructions = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line -> String.split(line, " ", trim: true) end)
  |> Enum.map(fn [op, num] -> {String.to_atom(op), String.to_integer(num)} end)

defmodule Console do
  def run(instructions, visited \\ %{}, pos \\ 0, acc \\ 0) do
    cond do
      Map.has_key?(visited, pos) || pos == length(instructions) ->
        {acc, pos == length(instructions)}
      true ->
        new_visited = Enum.into(%{pos => true}, visited)
        case Enum.at(instructions, pos) do
          {:acc, number} ->
            run(instructions, new_visited, pos + 1, acc + number)
          {:nop, _} ->
            run(instructions, new_visited, pos + 1, acc)
          {:jmp, number} ->
            run(instructions, new_visited, pos + number, acc)
        end
    end
  end
end

Console.run(instructions) |> elem(0) |> IO.inspect

Enum.each(0..(length(instructions)-1), fn i ->
  {op, number} = Enum.at(instructions, i)
  unless op == :acc do
    modified_instructions = Enum.with_index(instructions) |> Enum.map(fn {instr, index} ->
      if i != index do
        instr
      else
        case {op, number} do
          {:nop, number} -> {:jmp, number}
          {:jmp, number} -> {:nop, number}
        end
      end
    end)
    {acc, valid} = Console.run(modified_instructions)
    if valid do
      IO.puts(acc)
    end
  end
end)
