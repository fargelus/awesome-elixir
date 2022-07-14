defmodule AwesomeElixirWeb.GhReposInformerTask do
  @moduledoc """
  Fetch requires repos info from GitHub API.
  Prepare result as map like %{link: %{stars: 202, last_commit: 7}}.
  """

  @api_repo_path "https://api.github.com/repos"
  @token Application.fetch_env!(:github, :api_token)
  @gh_api_timeout 10000

  def run(links) do
    HTTPoison.start

    tasks = Enum.map(links, fn link ->
      Task.async(fn ->
        path = URI.parse(link) |> Map.fetch!(:path)
        gh_repo_request("#{@api_repo_path}#{path}")
      end)
    end)

    Task.await_many(tasks, @gh_api_timeout)
    |> Enum.reject(&is_nil/1)
    |> Enum.into(%{}, fn response ->
      {:ok, dt, _} = DateTime.from_iso8601(response["pushed_at"])
      data = %{
        stars: response["stargazers_count"],
        last_commit: days_from_commit(dt)
      }

      {response["html_url"], data}
    end)
  end

  defp gh_repo_request(repo_url) do
    headers = ["Authorization": "token #{@token}"]
    response = HTTPoison.get(repo_url, headers)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)

      {:ok, %HTTPoison.Response{status_code: 301, body: body}} ->
        info = Jason.decode!(body)
        gh_repo_request(info["url"])

      {:ok, _} -> nil
    end
  end

  defp days_from_commit(commit_dt) do
    commit_date = DateTime.to_date(commit_dt)
    Date.diff(Date.utc_today, commit_date)
  end
end
