defmodule Helpers do
  def combinations(list, num)
  def combinations(_list, 0), do: [[]]
  def combinations(list = [], _), do: list
  def combinations([head | tail], num) do
    Enum.map(combinations(tail, num - 1), &[head | &1]) ++
      combinations(tail, num)
  end
end