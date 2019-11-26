defmodule Day1 do
  def final_frequency(file_stream) do
    file_stream
    |> Stream.map(fn line ->
      {integer, _leftover} = Integer.parse(line)
      integer
    end)
    |> Enum.sum()
  end

  def repeat_frequency(file_stream) do
    file_stream
    |> Stream.map(fn line ->
      {integer, _leftover} = Integer.parse(line)
      integer
    end)
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn x, {current_frequency, seen_frequencies} ->
      new_frequency = current_frequency + x
      if new_frequency in seen_frequencies do
        {:halt, new_frequency}
      else
        {:cont, {new_frequency, MapSet.put(seen_frequencies, new_frequency)}}
      end
    end)
  end

  def repeat_frequency_eager(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {integer, _leftover} = Integer.parse(line)
      integer
    end)
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn x, {current_frequency, seen_frequencies} ->
      new_frequency = current_frequency + x
      if new_frequency in seen_frequencies do
        {:halt, new_frequency}
      else
        {:cont, {new_frequency, MapSet.put(seen_frequencies, new_frequency)}}
      end
    end)
  end
end

case System.argv do
  ["--test"] ->
    ExUnit.start()

    defmodule Day1Test do
      use ExUnit.Case

      import Day1

      test "final_frequency" do
        {:ok, io} = StringIO.open("""
        +1
        +1
        +1
        """)

        assert final_frequency(IO.stream(io, :line)) == 3
      end

      test "repeat_frequency" do
        io = [
        "+3\n",
        "+3\n",
        "+4\n",
        "-2\n",
        "-4\n"
        ]

        assert repeat_frequency(io) == 10
      end
    end

  [input_file] ->
    __DIR__ <> "/" <> input_file
    |> File.stream!([], :line)
    |> Day1.final_frequency()
    |> IO.puts

    __DIR__ <> "/" <> input_file
    |> File.stream!([], :line)
    |> Day1.repeat_frequency()
    |> IO.puts

    # __DIR__ <> "/" <> input_file
    # |> File.read!()
    # |> Day1.repeat_frequency_eager()
    # |> IO.puts

  _ ->
    IO.puts :stderr, "use --test or file name"
    System.halt(1)
end