defmodule Day3 do
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
    {:ok, input} = File.read(filename)

    expressions = Regex.scan(~r/mul\([0-9]{1,3},[0-9]{1,3}\)/, input, match: :all)

    Enum.reduce(expressions, 0, fn [expression], acc ->
      acc + evaluate_mul_expression(expression)
    end)
  end

  def part2(filename) do
    {:ok, input} = File.read(filename)

    mul_indices = ~r/mul\([0-9]{1,3},[0-9]{1,3}\)/
    |> Regex.scan(input, return: :index)
    |> Enum.map(fn [{idx, size}] -> {:mul, idx, size} end)

    do_indices = ~r/do\(\)/
    |> Regex.scan(input, return: :index)
    |> Enum.map(fn [{idx, size}] -> {:do, idx, size} end)

    dont_indices = ~r/don't\(\)/
    |> Regex.scan(input, return: :index)
    |> Enum.map(fn [{idx, size}] -> {:dont, idx, size} end)

    {_, answer} = [mul_indices, do_indices, dont_indices]
    |> Enum.concat()
    |> Enum.sort(fn {_type1, idx1, _size1}, {_type2, idx2, _size2} -> idx1 < idx2 end)
    |> Enum.reduce({true, 0}, fn {type, idx, size}, {do_instruction?, acc} ->
      case type do
        :mul ->
          if do_instruction? do
            {do_instruction?, acc + evaluate_mul_expression(String.slice(input, idx, size))}
          else
            {do_instruction?, acc}
          end

        :do -> {true, acc}
        :dont -> {false, acc}
      end
    end)

    answer

  end

  def evaluate_mul_expression(expression) do
    %{"op1" => op1, "op2" => op2} = Regex.named_captures(~r/mul\((?<op1>[0-9]{1,3}),(?<op2>[0-9]{1,3})/, expression)
    String.to_integer(op1) * String.to_integer(op2)
  end

end
