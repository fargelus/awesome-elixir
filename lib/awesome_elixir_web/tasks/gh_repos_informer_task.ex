defmodule AwesomeElixirWeb.GhReposInformerTask do
  @moduledoc """
  Fetch requires repos info from GitHub API.
  Prepare result as map like %{
    "https://github.com/fargelus/awesome-elixir": %{stars: 202, last_commit: 7}
  }.
  """

  @api_repo_path "https://api.github.com/repos"
  @token Application.fetch_env!(:github, :api_token)

  def run(links) do
    HTTPoison.start

    links_tasks = Enum.into(links, %{}, fn link ->
      task = Task.async(fn ->
        path = URI.parse(link) |> Map.fetch!(:path)
        gh_repo_request("#{@api_repo_path}#{path}")
      end)

      {link, task}
    end)

    links_tasks
    |> Enum.into(%{}, fn {link, task} -> {link, Task.await(task)} end)
    |> Enum.reject(fn {_, response} -> is_nil(response) end)
    |> Enum.into(%{}, fn {link, response} ->
      {:ok, dt, _} = DateTime.from_iso8601(response["pushed_at"])
      data = %{
        stars: response["stargazers_count"],
        last_commit: days_from_commit(dt)
      }

      {link, data}
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
