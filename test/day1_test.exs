defmodule Day1Test do
    use ExUnit.Case

    # test "parses the input" do
    #   assert Day1.parse_input("input/day01_example.txt") == ["1abc2","pqr3stu8vwx","a1b2c3d4e5f","treb7uchet"]
    # end

    test "part 1" do
      assert Day1.part1("input/day01_example.txt") == 11
    end

    test "part 2" do
      assert Day1.part2("input/day01_example.txt") == 31
    end
  end
