defmodule AwesomeElixirWeb.MdFetcherTask do
  @moduledoc """
  Fetch markdown file with awesome links from GitHub repo.
  """

  @md_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

  def run do
    HTTPoison.start
    {
      :ok,
      %HTTPoison.Response{status_code: 200, body: body}
    } = HTTPoison.get(@md_url)

    body
  end
end
