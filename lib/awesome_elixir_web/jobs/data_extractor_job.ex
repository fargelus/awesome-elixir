defmodule AwesomeElixirWeb.DataExtractorJob do
  @moduledoc """
  Fetch markdown from GitHub repo(https://github.com/h4cc/awesome-elixir).
  Transform it to html, fetch additional info and store it locally.
  """

  def run do
    markdown = AwesomeElixirWeb.MdFetcherTask.run()
    html = AwesomeElixirWeb.MdParserTask.run(markdown)
    File.write(AwesomeElixir.Const.index_file_path(), html)
  end
end
