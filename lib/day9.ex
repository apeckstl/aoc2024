defmodule Day9 do
  def parse_input(filename) do
    case File.read(filename) do
      {:ok, input} ->
        input

      {:error, message} ->
        "Error reading lines: #{message}"
    end
  end

  def part1(filename) do
    diskmap = filename
    |> parse_input()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)

    {occupied_spaces, free_spaces} = parse_diskmap_part1(diskmap, 0, 0, %{}, [])

    dbg("Parsing done")

    {compacted_blocks, _} = compact_part1(occupied_spaces, free_spaces)

    Enum.reduce(compacted_blocks, 0, fn {block_position, id}, acc -> acc + block_position * id end)

  end

  def part2(filename) do
    diskmap = filename
    |> parse_input()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)

    {occupied_spaces, free_spaces} = parse_diskmap_part2(diskmap, 0, 0, %{}, [])

    {compacted_blocks, _} = Enum.reduce(Enum.max(Map.keys(occupied_spaces))..0, {occupied_spaces, free_spaces}, fn file_id, {occupied_spaces, free_spaces} ->
      attempt_move_block_left(occupied_spaces, 0, file_id, free_spaces)
    end)

    Enum.reduce(compacted_blocks, 0, fn {id, {idx, size}}, acc ->
      acc + Enum.reduce(idx..idx+size-1, 0, fn offset_idx, file_acc -> file_acc + id * offset_idx end)
    end)

  end

  def attempt_move_block_left(occupied_map, free_list_idx, file_id, free_list) do
    {file_idx, file_size} = Map.get(occupied_map, file_id)
    {free_idx, free_size} = Enum.at(free_list, free_list_idx)

    cond do
      # there were no free blocks to the left of the file
      free_idx > file_idx -> {occupied_map, free_list}

      # the next free block is bigger than the file
      free_size > file_size -> {
        Map.put(occupied_map, file_id, {free_idx, file_size}),
        List.replace_at(free_list, free_list_idx, {free_idx + file_size, free_size - file_size})
      }

      # the next free block is the same size as the file
      free_size == file_size -> {
        Map.put(occupied_map, file_id, {free_idx, file_size}),
        List.delete_at(free_list, free_list_idx)
      }

      # we're about to reach the end of the free list
      free_list_idx + 1 == length(free_list) -> {occupied_map, free_list}

      # this block is not big enough, move on
      true -> attempt_move_block_left(occupied_map, free_list_idx + 1, file_id, free_list)

    end

  end

  # The end of parsing the input should be a list of free blocks, so we can use
  # the first available free spot when compacting, then the occupied map should be a
  # map of block positions to file ids, so [2, 3, 4, 8, 9, 10, ...] and
  # %{0: 0, 1: 0, 5: 1, 6: 1, 7: 1, ...}
  defp parse_diskmap_part1([occupied], block_position, file_id, occupied_map, free_list) do
    updated_occupied = Enum.reduce(0..occupied - 1, occupied_map, fn offset, acc_occupied ->
      Map.put(acc_occupied, block_position + offset, file_id)
    end)

    {updated_occupied, Enum.reverse(free_list)}
  end

  defp parse_diskmap_part1([occupied, free | remaining], block_position, file_id, occupied_map, free_list) do
    # first input would be [2, 3, | remaining], 0, 0, %{}, []
    # we want for i = 0..occupied, add an entry to the occupied map at block_position + i for file_id

    updated_occupied = unless occupied == 0 do
      Enum.reduce(0..occupied - 1, occupied_map, fn offset, acc_occupied ->
        Map.put(acc_occupied, block_position + offset, file_id)
      end)
    else
      occupied_map
    end

    updated_free = unless free == 0 do
      Enum.reduce(0..free - 1, free_list, fn offset, acc_free ->
        [block_position + occupied + offset | acc_free]
      end)
    else
      free_list
    end

    parse_diskmap_part1(remaining, block_position + occupied + free, file_id + 1, updated_occupied, updated_free)

  end

  # The end of parsing the input should be a list of free blocks, so we can use
  # the first available free spot when compacting, then the occupied map should be a
  # map of block positions to file ids, so [2, 3, 4, 8, 9, 10, ...] and
  # %{0: 0, 1: 0, 5: 1, 6: 1, 7: 1, ...}
  defp parse_diskmap_part2([occupied_size], block_position, file_id, occupied_map, free_list) do
    updated_occupied = Map.put(occupied_map, file_id, {block_position, occupied_size})

    {updated_occupied, Enum.reverse(free_list)}
  end

  defp parse_diskmap_part2([occupied_size, free_size | remaining], block_position, file_id, occupied_map, free_list) do
    # first input would be [2, 3, | remaining], 0, 0, %{}, []
    # we want for i = 0..occupied, add an entry to the occupied map at file_id for block_position to block_position + i

    updated_occupied = Map.put(occupied_map, file_id, {block_position, occupied_size})

    updated_free = unless free_size == 0 do
      [{block_position + occupied_size, free_size} | free_list]
    else
      free_list
    end

    parse_diskmap_part2(remaining, block_position + occupied_size + free_size, file_id + 1, updated_occupied, updated_free)

  end

  defp compacted?(occupied_map, free_list) do
    List.first(free_list) > Enum.max(Map.keys(occupied_map))
  end

  defp compact_part1(occupied_map, free_list) do
    if compacted?(occupied_map, free_list) do
      {occupied_map, free_list}
    else
      [first_free | remaining_free_list] = free_list

      block_to_clear = Enum.max(Map.keys(occupied_map))

      {block_id, removed_map} = Map.pop(occupied_map, block_to_clear)

      compact_part1(Map.put(removed_map, first_free, block_id), remaining_free_list)
    end

  end


end
