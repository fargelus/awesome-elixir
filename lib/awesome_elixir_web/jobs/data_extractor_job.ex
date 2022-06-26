defmodule AwesomeElixirWeb.DataExtractorJob do
  def run do
    markdown = AwesomeElixirWeb.MdFetcherJob.run()
    html = AwesomeElixirWeb.MdParserJob.run(markdown)
    File.write(AwesomeElixir.Const.index_file_path(), html)
  end
end
