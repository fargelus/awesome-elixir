defmodule AwesomeElixirWeb.PopularLibsTask do
  @moduledoc """
  Returns 20 most popular GitHub libs (by stars)
  """

  @amount 20

  def run do
    tmpl = File.read!(AwesomeElixir.Const.index_file_path())
    doc = Floki.parse_document!(tmpl)

    [
      {"h3", [], ["#{@amount} most popular repos"]},
      {"ul", [], sorted_items(doc)}
    ] |> Floki.raw_html
  end

  defp sorted_items(doc) do
    Floki.find(doc, "li")
    |> Enum.filter(fn item -> Floki.find(item, ".gh-repo-stars") != [] end)
    |> Enum.sort_by(fn date_item ->
      [{_, _, [stars_info]}] = Floki.find(date_item, ".gh-repo-stars")
      {stars, " ⭐"} = Integer.parse(stars_info)
      stars
    end, :desc)
    |> Enum.take(@amount)
  end
end
