IO.write("\e[H\e[2J")
IO.puts("Running #{__ENV__.file}...")

# sample_one = "light red bags contain 1 bright white bag, 2 muted yellow bags.
# dark orange bags contain 3 bright white bags, 4 muted yellow bags.
# bright white bags contain 1 shiny gold bag.
# muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
# shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
# dark olive bags contain 3 faded blue bags, 4 dotted black bags.
# vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
# faded blue bags contain no other bags.
# dotted black bags contain no other bags."

# sample_two = "shiny gold bags contain 2 dark red bags.
# dark red bags contain 2 dark orange bags.
# dark orange bags contain 2 dark yellow bags.
# dark yellow bags contain 2 dark green bags.
# dark green bags contain 2 dark blue bags.
# dark blue bags contain 2 dark violet bags.
# dark violet bags contain no other bags."

# rule_strings = String.split(sample_one, "\n", trim: true)

rule_strings = __DIR__ <> "/" <> "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

rules = Enum.reduce(rule_strings, %{}, fn x, acc ->
  container_match = Regex.run(~r/\A(.*) bags contain/, x)
  key = String.to_atom(Enum.at(container_match, 1))
  cond do
    Regex.match?(~r/bags contain no other bags./, x) ->
      Map.merge(acc, %{ key => [] })
    true ->
      contained = Regex.scan(~r/(\d+) (\w+ \w+) bag/, x)
      counts = Enum.map(contained, fn match ->
        {
          Enum.at(match, 1) |> String.to_integer,
          Enum.at(match, 2) |> String.to_atom
        }
      end)
      Map.merge(acc, %{ key => counts })
  end
end)

defmodule PartOne do
  def search(rules, key) do
    rule = Map.get(rules, key)
    Enum.count(rule) != 0 &&
    Enum.any?(rule, fn {_, atom} -> atom == :"shiny gold" end) ||
    Enum.any?(rule, fn {_, atom} -> search(rules, atom) end)
  end

  def run(rules) do
    Enum.count(Map.keys(rules), fn key ->
      search(rules, key)
    end)
  end
end

defmodule PartTwo do
  def pack(rules, key) do
    rule = Map.get(rules, key)
    inside = Enum.map(rule, fn {count, atom} ->
      count * pack(rules, atom)
    end) |> Enum.sum
    inside + 1
  end

  def run(rules), do: pack(rules, :"shiny gold") - 1
end

PartOne.run(rules) |> IO.inspect
PartTwo.run(rules) |> IO.inspect
