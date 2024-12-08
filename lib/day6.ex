defmodule Day6 do
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

    {map, location} = create_map(rows)

    spaces_covered = run_guard(map, location, {0, -1}, MapSet.new())

    spaces_covered
    |> Enum.map(fn {location, _direction} -> location end)
    |> Enum.count()

  end

  def part2(filename) do
    rows = parse_input(filename)

    {map, location} = create_map(rows)

    spaces_covered = map
    |> run_guard(location, {0, -1}, MapSet.new())
    |> Enum.map(fn {location, _direction} -> location end)
    |> Enum.uniq()

    Enum.reduce(spaces_covered, 0, fn coordinates = {x, y}, acc ->
      char = Map.get(map, coordinates)
      cond do
        char == "#" -> acc
        char == "^" -> acc
        coordinates == location -> acc
        match?(:loop, run_guard(Map.put(map, coordinates, "#"), location, {0, -1}, MapSet.new())) ->
          acc + 1

        true -> acc
      end
    end)
  end

  def create_map(rows) do
    {_, _, map, start} = Enum.reduce(rows, {0, 0, %{}, {}}, fn row, {_x, y, map, start} ->
      {_x, y, map, start} =
        Enum.reduce(String.graphemes(row), {0, y, map, start}, fn grapheme, {x, y, map, start} ->
          if grapheme == "^" do
            {x + 1, y, Map.put(map, {x, y}, grapheme), {x, y}}
          else
            {x + 1, y, Map.put(map, {x, y}, grapheme), start}
          end
        end)
      {0, y + 1, map, start}
    end)

    {map, start}
  end

  def rotate({0, -1}) do
    {1, 0}
  end

  def rotate({1, 0}) do
    {0, 1}
  end

  def rotate({0, 1}) do
    {-1, 0}
  end

  def rotate({-1, 0}) do
    {0, -1}
  end

  def attempt_move_one(map, _location = {x, y}, _direction = {up, down}) do
    next_loc = {x + up, y + down}

    case Map.get(map, next_loc) do
      nil -> :end

      "#" -> :obstruction

      _ -> next_loc
    end
  end

  def run_guard(map, location, direction, spaces_covered) do
    if MapSet.member?(spaces_covered, {location, direction}) do
      :loop
    else
      case attempt_move_one(map, location, direction) do
        :end -> MapSet.put(spaces_covered, {location, direction})
        :obstruction ->
          run_guard(map, location, rotate(direction), spaces_covered)

        next_location ->
          run_guard(map, next_location, direction, MapSet.put(spaces_covered, {location, direction}))

        end
      end
  end
end
