defmodule Day1 do
  def parse_input(filename) do
    case File.read(filename) do
      {:ok, lines} ->
        lines
        |> String.split("\n", trim: true)

      {:error, message} ->
        "Error reading lines: #{message}"
    end
  end

  def part1(filename) do
    lines = parse_input(filename)

    left = []
    right = []

    lines
    |> Enum.reduce({left, right}, fn line, {left, right} ->
      [first, second] = String.split(line, "   ")

      {[String.to_integer(first) | left], [String.to_integer(second) | right]}
    end)
    |> then(fn {left, right} ->
      left_sorted = Enum.sort(left)
      right_sorted = Enum.sort(right)

      Enum.zip_reduce(left_sorted, right_sorted, 0, fn x, y, acc ->
        abs(x - y) + acc
      end)
    end)

  end

  def part2(filename) do
    lines = parse_input(filename)

    left = []
    right = []

    lines
    |> Enum.reduce({left, right}, fn line, {left, right} ->
      [first, second] = String.split(line, "   ")

      {[String.to_integer(first) | left], [String.to_integer(second) | right]}
    end)
    |> then(fn {left, right} ->
      Enum.reduce(left, 0, fn elem, acc ->
        acc + elem * Enum.count(right, fn num -> num == elem end)
      end)
    end)
  end

end
