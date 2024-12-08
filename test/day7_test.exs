defmodule Day6Test do
  use ExUnit.Case

  test "evaluate viability" do
    assert Day7.evaluate("3267: 81 40 27", false) == true

    assert Day7.evaluate("83: 17 5", false) == false

    assert Day7.evaluate("21037: 9 7 18 13", false) == false

    assert Day7.evaluate("21037: 9 7 18 13", true) == false

    assert Day7.evaluate("7290: 6 8 6 15", true) == true
  end

  test "part 1" do
    assert Day7.part1("input/day07_example.txt") == 3749
  end

  test "part 2" do
    assert Day7.part2("input/day07_example.txt") == 11387
  end
end
