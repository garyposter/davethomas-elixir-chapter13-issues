defmodule CLITableTest do
  use ExUnit.Case
  doctest Issues.CLITable

  import Issues.CLITable, only: [
    get_row_data: 2,
    update_max_lengths: 2,
    generate_table_data_from_maps: 2,
    generate_divider: 1,
    generate_row: 2,
    generate_table: 2
  ]

  test "get_row_data works on the happy path" do
    assert get_row_data(
      %{"foo" => 42, "bar" => :yay, "baz" => "shazam"},
      ["baz", "foo"]) == ["shazam", "42"]
  end

  test "update_max_lengths works on the happy path" do
    assert update_max_lengths(
      ["123456", "1234", "1", "1234"], [5, 7, 2, 4]) == [6, 7, 2, 4]
  end

  test "generate_table_data_from_maps works on the happy path" do
    assert generate_table_data_from_maps(
      [%{"foo" => 42, "bar" => :yay, "baz" => "shazam"},
       %{"foo" => 1, "bar" => :yay, "baz" => "abracadabra"},
       %{"foo" => 50004, "bar" => :yay, "baz" => "phi"}],
      ["baz", "foo"]) == {
      [
        ["shazam", "42"],
        ["abracadabra", "1"],
        ["phi", "50004"]
      ],
      [11, 5]
    }
  end

  test "generate_divider works on happy path" do
    assert generate_divider([4, 2, 6]) == "━━━━━╋━━━━╋━━━━━━━"
  end

  test "generate_row works on the happy path" do
    assert generate_row(["philosophy", "4", "soda"], [4, 2, 8]) ==
      "phil ┃ 4  ┃ soda    "
  end

  test "generate_table works" do
    assert generate_table(
      {
        [
          ["shazam", "42"],
          ["abracadabra", "1"],
          ["phi", "50004"]
        ],
        [11, 5]
      },
      ["Silly", "Numbers"]) == [
        "Silly       ┃ Numbers",
        "━━━━━━━━━━━━╋━━━━━━━━",
        "shazam      ┃ 42     ",
        "abracadabra ┃ 1      ",
        "phi         ┃ 50004  "
      ]
  end
end
