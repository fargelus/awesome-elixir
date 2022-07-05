defmodule AwesomeElixirWeb.DataExtractorJob do
  def run do
    markdown = AwesomeElixirWeb.MdFetcherTask.run()
    html = AwesomeElixirWeb.MdParserTask.run(markdown)
    File.write(AwesomeElixir.Const.index_file_path(), html)
  end
end
