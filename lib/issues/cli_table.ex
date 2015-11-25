defmodule Issues.CLITable do

  @moduledoc """
  Helper functions to create CLI Tables.
  """

  def generate_table({table_data, lengths}, headers) do
    lengths = update_max_lengths(headers, lengths)
    [generate_row(headers, lengths) |
      [generate_divider(lengths) |
        Enum.map(table_data, &(generate_row(&1, lengths)))]]
  end

  def generate_row(content, lengths) do
    Enum.map_join(
      Enum.zip(content, lengths),
      " \u2503 ", # ┃
      fn({string, length}) ->
        String.ljust(String.slice(string, 0, length), length)
      end)
  end

  def generate_divider(lengths) do
    Enum.map_join(
      lengths,
      "\u2501\u254B\u2501", # ━╋━
      fn(length) ->
        String.duplicate("\u2501", length) # ━
      end)
  end

  def generate_table_data_from_maps(issues, keys) do
    lengths = List.duplicate(0, Enum.count(keys))
    Enum.map_reduce(
      issues,
      lengths,
      fn(issue, lengths) ->
        strings = get_row_data(issue, keys)
        {strings, update_max_lengths(strings, lengths)}
      end)
  end

  def update_max_lengths(strings, lengths) do
    Enum.map(
      Enum.zip(strings, lengths),
      fn({string, max_length}) ->
        max(String.length(string), max_length)
      end)
  end

  def get_row_data(map, keys) do
    keys |> Enum.map(&(map[&1])) |> Enum.map(&to_string/1)
  end

end
