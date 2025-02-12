defmodule Day10 do
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

    {map, trailheads} = create_map(rows)

    Enum.reduce(trailheads, 0, fn trailhead, acc ->
      score = get_trailhead_score(map, trailhead)

      acc + score
    end)
  end

  def part2(filename) do
    rows = parse_input(filename)

    {map, trailheads} = create_map(rows)

    Enum.reduce(trailheads, 0, fn trailhead, acc ->
      score = get_trailhead_rating(map, trailhead)

      acc + score
    end)

  end

  def create_map(rows) do
    {_, _, map, trailheads} = Enum.reduce(rows, {0, 0, %{}, []}, fn row, {_x, y, map, trailheads} ->
      {_x, y, map, trailheads} =
        Enum.reduce(String.graphemes(row), {0, y, map, trailheads}, fn height, {x, y, map, trailheads} ->
          if height == "0" do
            {x + 1, y, Map.put(map, {x, y}, 0), [{x, y} | trailheads]}
          else
            {x + 1, y, Map.put(map, {x, y}, String.to_integer(height)), trailheads}
          end
        end)
      {0, y + 1, map, trailheads}
    end)

    {map, trailheads}
  end

  def get_trailhead_score(map, trailhead) do
    map
    |> check_path(trailhead)
    |> Enum.uniq()
    |> length()
  end

  def get_trailhead_rating(map, trailhead) do
    map
    |> check_path(trailhead)
    |> length()
  end

  def check_path(map, {x, y}) do
    directions = [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    current_height = Map.get(map, {x, y})

    Enum.reduce(directions, [], fn direction_to_check, acc ->
      peaks = case Map.get(map, direction_to_check) do
        nil -> []
        9 -> if current_height == 8 do [direction_to_check] else [] end
        step ->
          if step - 1 == current_height do
            check_path(map, direction_to_check)
          else
            []
          end

      end

      acc ++ peaks

    end)
  end


end
