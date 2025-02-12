defmodule Day11Test do
  use ExUnit.Case

  test "part 1" do
    assert Day11.part1("input/day11_example.txt") == 55312
  end

  test "part 2" do
    assert Day11.part2("input/day11_example.txt") == 65601038650482
  end
end
