defmodule Day12 do
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

    garden_map = create_map(rows)

    {_, total_price} = Enum.reduce(garden_map, {garden_map, 0}, fn {{x, y}, {_, _}}, {gm, acc} ->
      {plant_type, visited?} = Map.get(gm, {x, y})

      if visited? do
        {gm, acc}
      else
        {updated_garden_map, area, perimeter} = measure_region(gm, {x, y}, plant_type, 0, 0)
        {updated_garden_map, acc + area * perimeter}
      end
    end)
    total_price

  end

  def part2(filename) do

  end

  def create_map(rows) do
    {_, _, map} = Enum.reduce(rows, {0, 0, %{}}, fn row, {_x, y, map} ->
      {_x, y, map} =
        Enum.reduce(String.graphemes(row), {0, y, map}, fn plant_type, {x, y, map} ->
          {x + 1, y, Map.put(map, {x, y}, {plant_type, false})}
        end)
      {0, y + 1, map}
    end)

    map
  end

  def measure_region(garden_map, {x, y}, current_plant_type, area, perimeter) do
    # {a, b} = Map.get(garden_map, {x, y})
    # dbg("Letter at {#{x}, #{y}}: {#{a}, #{b}}")
    # dbg("current_plant_type: #{current_plant_type}")

    case Map.get(garden_map, {x, y}) do
      nil ->
        {garden_map, area, perimeter + 1}
      {plant_type, visited?} ->
        cond do
          plant_type == current_plant_type and visited? ->
            {garden_map, area, perimeter}
          plant_type == current_plant_type ->
            # this is another plot in the region to count, so we need to call measure_region
            # on all its neighbors
            updated_garden_map = Map.put(garden_map, {x, y}, {current_plant_type, true})
            updated_area = area + 1

            {south_gm, south_a, south_p} = measure_region(updated_garden_map, {x, y + 1}, current_plant_type, updated_area, perimeter)
            {north_gm, north_a, north_p} = measure_region(south_gm, {x, y - 1}, current_plant_type, south_a, south_p)
            {west_gm, west_a, west_p} = measure_region(north_gm, {x - 1, y}, current_plant_type, north_a, north_p)
            measure_region(west_gm, {x + 1, y}, current_plant_type, west_a, west_p)

          true ->
            {garden_map, area, perimeter + 1}
        end
      _ -> "ERROR"
    end

  end

end
