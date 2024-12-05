defmodule Day4 do
  @opposites %{
    "M" => "S",
    "S" => "M"
  }

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

    size = length(rows)

    {board, _} = create_board(rows)

    rows_total = Enum.reduce(rows, 0, fn elem, acc ->
      acc + number_of_matches(elem)
    end)

    columns_total = board
    |> get_columns(size)
    |> Enum.reduce(0, fn elem, acc ->
      acc + number_of_matches(elem)
    end)

    negative_slope_total = board
    |> get_negative_slope_lines(size)
    |> Enum.reduce(0, fn elem, acc ->
      acc + number_of_matches(elem)
    end)

    positive_slope_total = board
    |> get_positive_slope_lines(size)
    |> Enum.reduce(0, fn elem, acc ->
      acc + number_of_matches(elem)
    end)

    rows_total + columns_total + negative_slope_total + positive_slope_total
  end

  def part2(filename) do
    rows = parse_input(filename)

    {board, a_positions} = create_board(rows)

    Enum.count(a_positions, fn {x, y} ->
      is_x?({x,y},board,length(rows))
    end)

  end

  def is_x?({x, y}, board, size) do
    top_left = {x-1,y-1}
    top_right = {x+1,y-1}

    if !is_edge?({x, y}, board, size) do
      tops? = (Map.get(board,top_left) == "S" or Map.get(board,top_left) == "M") and (Map.get(board,top_right) == "S" or Map.get(board,top_right) == "M")

      if tops? do
        opposite_character_is_opposite?({x,y}, top_left, board) and opposite_character_is_opposite?({x,y}, top_right, board)
      else
        false
      end
    else
      false
    end


  end

  def is_edge?({x, y}, board, size) do
    x == 0 or x == size - 1 or y == 0 or y == size - 1
  end

  def number_of_matches(line_list) when is_list(line_list) do
    line = Enum.join(line_list)
    length(Regex.scan(~r/XMAS/, line)) + length(Regex.scan(~r/SAMX/, line))
  end

  def number_of_matches(line) do
    length(Regex.scan(~r/XMAS/, line)) + length(Regex.scan(~r/SAMX/, line))
  end

  def create_board(rows) do
    {_, _, board_map, a_positions} = Enum.reduce(rows, {0, 0, %{}, []}, fn row, {_x, y, board, as} ->
      {_x, y, updated_board, updated_as} =
        Enum.reduce(String.graphemes(row), {0, y, board, as}, fn grapheme, {x, y, board, as} ->
          if grapheme == "A" do
            {x + 1, y, Map.put(board, {x, y}, grapheme), [{x, y} | as]}
          else
            {x + 1, y, Map.put(board, {x, y}, grapheme), as}
          end
        end)
      {0, y + 1, updated_board, updated_as}
    end)

    {board_map, a_positions}
  end

  def opposite_character_is_opposite?(a_position = {a_x, a_y}, my_position = {m_x, m_y}, board) do
    x_diff = m_x - a_x
    y_diff = m_y - a_y

    opp_position = {a_x - x_diff, a_y - y_diff}

    Map.get(board, my_position) == Map.get(@opposites, Map.get(board, opp_position))
  end

  def get_columns(board, size) do
    Enum.map(0..(size - 1), fn x ->
      Enum.map(0..(size - 1), fn y ->
        Map.get(board, {x, y})
      end)
    end)
  end

  def get_negative_slope_lines(board, size) do
    # above and incl the meridian

    above = Enum.map(0..(size - 1), fn x ->
      Enum.map(0..size - x - 1, fn y ->
        Map.get(board, {x + y, y})
      end)
    end)

    below = Enum.map(0..(size - 1), fn y ->
      Enum.map(0..(size - y - 2), fn x ->
        Map.get(board, {x, x + y + 1})
      end)
    end)

    Enum.concat(above, below)
  end

  def get_positive_slope_lines(board, size) do
    # above and incl the meridian

    above = Enum.map(0..(size - 1), fn x ->
      Enum.map(Enum.reverse(0..size-1-x), fn y ->
        Map.get(board,{size-1-x-y, y})
      end)
    end)

    below = Enum.map(1..(size - 1), fn x ->
      Enum.map(0..(size - x - 1), fn y ->
        Map.get(board, {x + y, size - 1 - y})
      end)
    end)

    Enum.concat(above, below)
  end

end
