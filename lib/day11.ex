defmodule Day11 do
  require Integer

  def parse_input(filename) do
    case File.read(filename) do
      {:ok, input} ->
        input

      {:error, message} ->
        "Error reading lines: #{message}"
    end
  end

  def part1(filename) do
    stones = filename
    |> parse_input()
    |> String.split(" ")
    |> Enum.reduce(%{}, fn stone, acc -> Map.update(acc, stone, 1, fn tally -> tally + 1 end) end)

    Enum.reduce(1..25, stones, fn blink, acc ->
      acc
      |> Enum.reduce(%{}, &run_transformation(&1, &2))
    end)
    |> Enum.reduce(0, fn {stone, count}, acc -> acc + count end)
  end

  def part2(filename) do
    stones = filename
    |> parse_input()
    |> String.split(" ")
    |> Enum.reduce(%{}, fn stone, acc -> Map.update(acc, stone, 1, fn tally -> tally + 1 end) end)

    Enum.reduce(1..75, stones, fn blink, acc ->
      acc
      |> Enum.reduce(%{}, &run_transformation(&1, &2))
    end)
    |> Enum.reduce(0, fn {stone, count}, acc -> acc + count end)
  end

  def run_transformation({stone, count}, new_set) do
    cond do
      stone == "0" -> Map.update(new_set, "1", count, fn existing -> existing + count end)
      Integer.is_even(length(String.graphemes(stone))) ->
        stone
          |> String.split_at(div(length(String.graphemes(stone)), 2))
          |> Tuple.to_list()
          |> Enum.map(&String.to_integer/1)
          |> Enum.map(&Integer.to_string/1)
          |> Enum.reduce(new_set, fn new, set -> Map.update(set, new, count, fn existing -> existing + count end) end)
      true ->
        stone
        |> String.to_integer()
        |> Kernel.*(2024)
        |> Integer.to_string()
        |> then(&Map.update(new_set, &1, count, fn existing -> existing + count end))
    end


  end

end
