defmodule Day8 do
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

    map = create_map(rows)

    map
    |> Enum.reduce([], fn {_, antennae}, acc ->
      pairs = for x <- antennae, y <- antennae, x != y, do: antinodes_for_pair(x, y)

      [pairs | acc]
    end)
    |> List.flatten()
    |> Enum.filter(&coordinates_in_bounds(&1, length(rows)))
    |> Enum.uniq()
    |> Enum.count()

  end

  def part2(filename) do
    rows = parse_input(filename)

    map = create_map(rows)

    map
    |> Enum.reduce([], fn {_, antennae}, acc ->
      pairs = for x <- antennae, y <- antennae, x != y, do: antinodes_for_pair_part_2(x, y, length(rows))

      [pairs | acc]
    end)
    |> List.flatten()
    |> Enum.filter(&coordinates_in_bounds(&1, length(rows)))
    |> Enum.uniq()
    |> Enum.count()
  end

  def create_map(rows) do
    {_, _, map} = Enum.reduce(rows, {0, 0, %{}}, fn row, {_x, y, map} ->
      {_x, y, map} =
        Enum.reduce(String.graphemes(row), {0, y, map}, fn grapheme, {x, y, map} ->
          if grapheme != "." do
            coords = Map.get(map, grapheme)
            if is_nil(coords) do
              {x + 1, y, Map.put(map, grapheme, [{x, y}])}
            else
              {x + 1, y, Map.put(map, grapheme, [{x, y} | coords])}
            end
          else
            {x + 1, y, map}
          end
        end)
      {0, y + 1, map}
    end)

    map
  end

  def coordinates_in_bounds({x, y}, size) do
    x >= 0 and x < size and y >= 0 and y < size
  end

  def antinodes_for_pair({a, b}, {c, d}) do
    antinode_1 = {a + (a - c), b + (b - d)}
    antinode_2 = {c + (c - a), d + (d - b)}

    [antinode_1, antinode_2]
  end

  def antinodes_for_pair_part_2({a, b}, {c, d}, size) do
    rise = d - b
    run = c - a

    positive = line([{a, b}], rise, run, size)
    negative = line([{a, b}], -rise, -run, size)

    positive ++ negative
  end

  def line(points, rise, run, size) do
    [{last_x, last_y} | rest] = points

    if last_x + run >= size or last_x + run < 0 or last_y + rise >= size or last_y + rise < 0 do
      points
    else
      line([{last_x + run, last_y + rise} | points], rise, run, size)
    end
  end
end
