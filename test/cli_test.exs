defmodule CliTest do
  use ExUnit.Case
  import Issues.CLI, only: [parse_args: 1]

  test "-h and --help work" do
    assert parse_args(["-h"]) == :help
    assert parse_args(["--help"]) == :help
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three arguments correctly parsed" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "bad counts generate help" do
    assert parse_args(["user", "project", "hi"]) == :help
  end

  test "two arguments correctly parsed" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "other things generate help" do
    assert parse_args(["user"]) == :help
    assert parse_args(["--unknown"]) == :help
  end
end
