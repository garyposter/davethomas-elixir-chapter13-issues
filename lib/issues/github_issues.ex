defmodule Issues.GitHubIssues do
  @user_agent [{"User-agent", "Elixir Tutorial Project gary@modernsongs.com"}]
  @github_url Application.get_env(:issues, :github_url)
  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project), do:
    "#{@github_url}/repos/#{user}/#{project}/issues"

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}),
    do: {:ok, Poison.decode!(body)}
  def handle_response({:ok, %HTTPoison.Response{status_code: ___, body: body}}),
    do: {:error, Poison.decode!(body)}
  def handle_response({:error, response}), do: {:error, response}

  def sort_from_oldest_creation_time(issues) do
    Enum.sort(issues, fn(i1, i2) -> i1["created_at"] <= i2["created_at"] end)
  end

end
