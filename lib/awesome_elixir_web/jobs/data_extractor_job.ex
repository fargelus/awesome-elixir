defmodule AwesomeElixirWeb.DataExtractorJob do
  def run do
    markdown = AwesomeElixirWeb.MdFetcherJob.run()
    html = AwesomeElixirWeb.MdParserJob.run(markdown)

    ConCache.put(
      AwesomeElixir.Const.Cache.name,
      AwesomeElixir.Const.Cache.template_key,
      %ConCache.Item{value: html, ttl: :infinity}
    )
  end
end
