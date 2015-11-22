defmodule GitHubIssuesTest do
  use ExUnit.Case
  import Issues.GitHubIssues, only: [issues_url: 2, handle_response: 1]

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
end
