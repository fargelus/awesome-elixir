defmodule Mix.Tasks.AwesomeElixir.DataFetcher do
  @moduledoc false
  use Mix.Task

  def run(_) do
    :inets.start
    :ssl.start

    {:ok, result} = md_url()
                    |> String.to_charlist
                    |> :httpc.request
    {_status, _headers, body} = result
    body
  end

  defp md_url do
    "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"
  end
end
