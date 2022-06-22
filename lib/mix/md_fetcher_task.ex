defmodule Mix.Tasks.AwesomeElixir.MdFetcher do
  @moduledoc false
  @md_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

  use Mix.Task

  def run(_) do
    HTTPoison.start
    {
      :ok,
      %HTTPoison.Response{status_code: 200, body: body}
    } = HTTPoison.get(@md_url)

    body
  end
end
