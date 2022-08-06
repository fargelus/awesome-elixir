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
    |> rm_empty_categories
    |> rm_navigation
    |> Floki.raw_html
  end

  defp removed_items(doc, min_stars) do
    Floki.find(doc, "li")
    |> Enum.filter(fn item -> Floki.find(item, "a[href^=\"#\"]") == [] end)
    |> Enum.filter(fn node ->
      stars_node = Floki.find(node, ".gh-repo-stars")
                   |> Enum.at(0)

      if is_tuple(stars_node) do
        {_, _, [stars_info]} = stars_node
        {stars, " ⭐"} = Integer.parse(stars_info)
        stars < min_stars
      else
        true
      end
    end)
  end

  defp rm_empty_categories(doc) do
    indexes = empty_categories_indexes(doc)

    Enum.with_index(doc)
    |> Enum.reject(fn {_, index} -> Enum.member?(indexes, index) end)
    |> Enum.map(fn {node, _} -> node end)
  end

  defp empty_categories_indexes(doc) do
    Enum.with_index(doc)
    |> Enum.map(fn {node, index} ->
      case node do
        {"ul", [], []} -> [index - 2, index - 1, index]

        _ -> nil
      end
    end)
    |> Enum.filter(&is_list/1)
    |> List.flatten
  end

  defp rm_navigation(doc) do
    Floki.traverse_and_update(doc, fn
      {"li", [], [{"a", [{"href", href}], heading}]} = node ->
        if String.match?(href, ~r/^#/) do
          header = Floki.find(doc, "h2:fl-contains(\"#{heading}\")")
          if header == [], do: nil, else: node
        else
          node
        end

      other -> other
    end)
  end
end
