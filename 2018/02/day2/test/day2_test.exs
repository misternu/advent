defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "count_characters" do
    assert Day2.count_characters("aabbcc") == %{
      ?a => 2,
      ?b => 2,
      ?c => 2
    }
  end

  test "closest" do
    assert Day2.closest([
      "abcde",
      "fghij",
      "klmno",
      "pqrst",
      "fguij",
      "axcye",
      "wvxyz"
    ]) == "fgij"
  end
end
