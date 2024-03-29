defmodule Issues.CLI do

  @default_count 4

  @moduledoc """
  Command line parsing and dispatch for generating a table of the oldest
  _n_ issues in a given github project.
  """

  def main(argv) do
    parse_args(argv)
    |> process
  end

  @doc """
  `argv` can include -h/--help, which will display a help message.

  Otherwise, argv should include a GitHub user, a project name, and an optional
  count of projects to display, defaulting to #{@default_count}.

  Returns `:help` if it is requested, or if inputs are not understood; and
  otherwise a tuple of `{user name, project name, count}`.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                      aliases: [h: :help])
    case parse do
      {[help: true], _, _} -> :help
      {_, [user, project, count], _} ->
        case Integer.parse(count) do
          {count, ""} -> {user, project, count}
          _ -> :help
        end
      {_, [user, project], _} -> {user, project, @default_count}
      {_, _, _} -> :help
    end
  end

  def process(:help) do
    IO.puts """
    Get the most recent GitHub issues for a project.

    Usage: issues <user> <project> [ <count> | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GitHubIssues.fetch(user, project)
    |> decode_response
    |> Issues.GitHubIssues.sort_from_oldest_creation_time
    |> Enum.take(count)
    |> Issues.CLITable.generate_table_data_from_maps(
      ["number", "created_at", "title"])
    |> Issues.CLITable.generate_table(["#", "Created at", "Title"])
    |> Enum.map(&IO.puts/1)
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, %{"message": message}}) do
    IO.puts("Error fetching from GitHub: #{message}")
    System.halt(2)
  end
  def decode_response({:error, response}) do
    IO.puts("Unexpected error connecting to GitHub.")
    IO.inspect(response)
    System.halt(3)
  end

end
