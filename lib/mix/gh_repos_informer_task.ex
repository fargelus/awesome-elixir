defmodule Mix.Tasks.AwesomeElixir.GhReposInformer do
  @moduledoc false
  @api_repo_path "https://api.github.com/repos"

  use Mix.Task

  def run(links) do
    parent_process = self()
    HTTPoison.start

    Enum.each(links, fn link ->
      spawn fn ->
        try do
          path = URI.parse(link) |> Map.fetch!(:path)
          response = gh_repo_request(path)
          send(parent_process, {:ok, {link, response}})
        rescue
          e -> send(parent_process, :error)
        end
      end
    end)

    repos_info = %{}
    receive do
      {:ok, {link, response}} ->
        {:ok, dt, _} = DateTime.from_iso8601(response["pushed_at"])

        repos_info = Map.put(repos_info, link, %{
          stars: response["stargazers_count"],
          last_commit: days_from_commit(dt)
        })
    after
      2_000 -> nil
    end
  end

  defp gh_repo_request(path) do
    repo_url = "#{@api_repo_path}#{path}"
    {
      :ok,
      %HTTPoison.Response{status_code: 200, body: body}
    } = HTTPoison.get(repo_url)
    Jason.decode!(body)
  end

  defp days_from_commit(commit_dt) do
    commit_date = DateTime.to_date(commit_dt)
    Date.diff(Date.utc_today, commit_date)
  end
end
