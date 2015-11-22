defmodule GitHubIssuesTest do
  use ExUnit.Case
  import Issues.GitHubIssues, only: [
    issues_url: 2,
    handle_response: 1,
    sort_from_oldest_creation_time: 1
  ]

  test "issues_url assembles expected url" do
    assert issues_url("foo", "bar") ==
      "#{Application.get_env(:issues, :github_url)}/repos/foo/bar/issues"
  end

  test "handle_response accepts happy path" do
    assert handle_response(
      {:ok,
       %HTTPoison.Response{
         status_code: 200, body: ~S("hiya"), headers: "whatever"}}
      ) == {:ok, "hiya"}
  end

  test "handle_response accepts sad path" do
    assert handle_response(
      {:ok,
       %HTTPoison.Response{
         status_code: 404, body: ~S("boo"), headers: "whatever"}}
      ) == {:error, "boo"}
  end

  test "handle_response accepts super sad path" do
    assert handle_response(
      {:error, "feather"}
      ) == {:error, "feather"}
  end

  test "sort_from_oldest_creation_time sorts the right direction" do
    result = sort_from_oldest_creation_time(fake_created_at_list(~w{3 2 4 1}))
    assert Enum.map(result, &(&1["created_at"])) == ~w{1 2 3 4}
  end

  def fake_created_at_list(items) do
    Enum.map(items, &(%{"created_at" => &1, "other" => "info"}))
  end
end
