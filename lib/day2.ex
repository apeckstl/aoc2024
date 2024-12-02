defmodule Day2 do
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
    reports =
      filename
      |> parse_input()
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn report ->
        Enum.map(report, &String.to_integer/1)
      end)

    reports
    |> Enum.count(&is_valid_report?/1)

  end

  def part2(filename) do
    reports =
      filename
      |> parse_input()
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn report ->
        Enum.map(report, &String.to_integer/1)
      end)

    reports
    |> Enum.map(&check_permutation?(&1, -1))
    |> Enum.count(&(&1))

  end

  def is_valid_report?(report) do
    initial_diff = Enum.at(report, 1) - Enum.at(report, 0)

    multiplier = cond do
      abs(initial_diff) > 3 or abs(initial_diff) < 1 -> 0

      initial_diff > 0 -> 1

      initial_diff < 0 -> -1

    end

    [_ | leading] = report
    trailing = Enum.take(report, length(report) - 1)

    Enum.zip_reduce([leading, trailing], true, fn [current, previous], acc ->
      acc && ((current - previous) * multiplier > 0 && (current - previous) * multiplier < 4)
    end)
  end

  def check_permutation?(report, idx_to_check) do
    cond do
      idx_to_check == -1 and is_valid_report?(report) ->
        true

      idx_to_check == length(report) ->
        false

      idx_to_check != -1 and is_valid_report?(List.delete_at(report, idx_to_check)) ->
        true

      true ->
        check_permutation?(report, idx_to_check + 1)
    end
  end

end
