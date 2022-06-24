defmodule AwesomeElixirWeb.MdParserJob do
  def run(markdown) do
    {:ok, raw_html, _} = markdown |> Earmark.as_html
    {:ok, html} = Floki.parse_document(raw_html)

    updated_html_tree(html) |> Floki.raw_html
  end

  defp updated_html_tree(html) do
    links = parse_links(html)
    repos_info = AwesomeElixirWeb.GhReposInformerJob.run(links)

    Enum.reduce(repos_info, html, fn {url, data}, html ->
      Floki.traverse_and_update(html, fn
        {"li", [], [{"a", [{"href", ^url}], text}, desc]} ->
          %{stars: stars, last_commit: days} = data
          new_tag = {"span", [], ["#{stars} stars, committed #{days} days ago"]}
          {"li", [], [{"a", [{"href", url}], text}, desc, new_tag]}

        other -> other
      end)
    end)
  end

  defp parse_links(document) do
    # document
    # |> Floki.find("li a[href^=\"https://github.com\"]")
    # |> Enum.map(fn anchor ->
    #   {"a", [{_, href}], _} = anchor
    #   href
    # end)
    ["https://github.com/stocks29/dlist"]
  end
end
