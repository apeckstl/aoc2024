defmodule Day7 do
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
    rows = parse_input(filename)

    rows
    |> Enum.filter(&evaluate(&1, false))
    |> Enum.map(fn input ->
      [tcr, _] = String.split(input, ": ")
      String.to_integer(tcr)
    end)
    |> Enum.sum()


  end

  def part2(filename) do
    rows = parse_input(filename)

    rows
    |> Enum.filter(&evaluate(&1, true))
    |> Enum.map(fn input ->
      [tcr, _] = String.split(input, ": ")
      String.to_integer(tcr)
    end)
    |> Enum.sum()
  end

  def evaluate(input, use_concatenate?) do
    [outcome, operand_string] = String.split(input, ": ")

    operands = operand_string
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)

    next_operand(String.to_integer(outcome), operands, 0, use_concatenate?)
  end

  def next_operand(outcome, [], current_total, _) do
    if current_total == outcome do
      true
    else
      false
    end
  end

  def next_operand(outcome, remaining_operands, current_total, true) do
    if current_total > outcome do
      false
    else
      [head | tail] = remaining_operands

      next_operand(outcome, tail, current_total * head, true) or next_operand(outcome, tail, current_total + head, true)
        or next_operand(outcome, tail, concatenate(current_total, head), true)
    end
  end

  def next_operand(outcome, remaining_operands, current_total, false) do
    if current_total > outcome do
      false
    else
      [head | tail] = remaining_operands

      next_operand(outcome, tail, current_total * head, false) or next_operand(outcome, tail, current_total + head, false)
    end
  end

  def concatenate(left, right) do
    String.to_integer(Integer.to_string(left) <> Integer.to_string(right))
  end

end
