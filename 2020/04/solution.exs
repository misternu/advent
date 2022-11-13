defmodule Solution do
  def has_all_requirements(line) do
    keys = Enum.map(line, fn [head | _] -> head end)
    requirements = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    Enum.all?(requirements, fn req -> req in keys end)
  end

  def valid(line) do
    Enum.all?(line, fn [key, val] ->
      case key do
      "byr" -> {year, _} = Integer.parse(val); year >= 1920 && year <= 2002
      "iyr" -> {year, _} = Integer.parse(val); year >= 2010 && year <= 2020
      "eyr" -> {year, _} = Integer.parse(val); year >= 2020 && year <= 2030
      "hgt" ->
        {number, unit} = Integer.parse(val)
        (unit == "cm" && number >= 150 && number <= 193) ||
        (unit == "in" && number >= 59 && number <= 76)
      "hcl" -> Regex.match?(~r/^#[0-9a-f]{6}$/, val)
      "ecl" -> Regex.match?(~r/(amb|blu|brn|gry|grn|hzl|oth)/, val)
      "pid" -> Regex.match?(~r/^\d{9}$/, val)
      _ -> true end
    end)
  end

  def run do
    lines = __DIR__ <> "/" <> "input.txt"
      |> File.read!()
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn p ->
        Enum.map(String.split(p, ~r{\s+}), fn x ->
          String.split(x, ":")
        end)
      end)

    Enum.count(lines, fn line -> has_all_requirements(line) end) |> IO.inspect
    Enum.count(lines, fn line -> has_all_requirements(line) && valid(line) end) |> IO.inspect
  end
end

IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")
Solution.run