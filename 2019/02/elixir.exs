defmodule IntcodeComputer do
  def operate(program, address, 1) do
    [a, b, c] = params(program, address, 3)
    operate(
      List.replace_at(program, c, a + b),
      address + 4,
      Enum.at(program, address + 4)
    )
  end

  def operate(program, address, 2) do
    [a, b, c] = params(program, address, 3)
    operate(
      List.replace_at(program, c, a * b),
      address + 4,
      Enum.at(program, address + 4)
    )
  end

  def operate(program, _address, 99) do
    Enum.at(program, 0)
  end

  def run(program) do
    operate(program, 0, Enum.at(program,0))
  end

  def params(program, address, 3) do
    [a | [b | [c | _tail]]] = Enum.drop(program, address + 1)
    [a_val, b_val] = [a, b] |> Enum.map(fn x -> Enum.at(program, x) end)
    [a_val, b_val, c]
  end

  def run(program, noun, verb) do
    program = List.replace_at(program, 1, noun)
    program = List.replace_at(program, 2, verb)
    operate(program, 0, Enum.at(program,0))
  end
end

input = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split(",", trim: true)
  |> Enum.map(fn line ->
    {integer, _leftover} = Integer.parse(line)
    integer
  end)

# Part 1
IO.inspect IntcodeComputer.run(input, 12, 2)

# Part 2
target = 19690720
for noun <- 0..99,
    verb <- 0..99 do
  output = IntcodeComputer.run(input, noun, verb)
  if output == target do
    IO.puts((100 * noun) + verb)
  end
end
