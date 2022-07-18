defmodule AwesomeElixirWeb.LibraryStarsFilterTask do
  @moduledoc """
  Filter html template content.
  Delete libraries with stars < :min_stars.
  """

  def run(min_stars) do
    tmpl = File.read!(AwesomeElixir.Const.index_file_path())
    doc = Floki.parse_document!(tmpl)

    items_for_remove = removed_items(doc, min_stars)
    Floki.traverse_and_update(doc, fn node ->
      if Enum.member?(items_for_remove, node), do: nil, else: node
    end)
    |> Floki.raw_html
  end

  defp removed_items(doc, min_stars) do
    Floki.find(doc, "li")
    |> Enum.filter(fn node ->
      html = Floki.raw_html(node)
      stars_node = Floki.find(html, ".gh-repo-stars")
                   |> Enum.at(0)

      if is_tuple(stars_node) do
        {_, _, [stars_info]} = stars_node
        {stars, " ⭐"} = Integer.parse(stars_info)
        stars < min_stars
      end
    end)
  end
end
