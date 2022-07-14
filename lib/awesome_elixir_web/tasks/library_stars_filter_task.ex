defmodule AwesomeElixirWeb.LibraryStarsFilterTask do
  @moduledoc """
  Filter html template content.
  Delete libraries with stars < :min_stars.
  """

  def run(min_stars) do
    tmpl = File.read!(AwesomeElixir.Const.index_file_path())
    doc = Floki.parse_document!(tmpl)
    filter_by_stars(doc, min_stars) |> Floki.raw_html
  end

  defp filter_by_stars(doc, min_stars) do
    Floki.traverse_and_update(doc, fn node ->
      case node do
        {"li", _, [_, _, {"span", [], [stars_info]}, _]} ->
          try do
            {stars, " ⭐"} = Integer.parse(stars_info)
            if stars < min_stars, do: nil, else: node
          rescue
            MatchError -> node
          end

        _ -> node
      end
    end)
  end
end
