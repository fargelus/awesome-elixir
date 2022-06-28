defmodule AwesomeElixirWeb.MdParserJob do
  def run(markdown) do
    {:ok, raw_html, _} = markdown |> Earmark.as_html
    {:ok, html} = Floki.parse_document(raw_html)

    html
    |> cut_document
    |> make_navigation
    |> updated_html_tree
    |> Floki.raw_html
  end

  defp cut_document(html) do
    Floki.find_and_update(html, "ul:first-of-type ~ *", fn _ -> :delete end)
  end

  defp make_navigation(html) do
    Floki.find(html, "a[href^=\"#\"]")
    |> Enum.reduce(html, fn link, html ->
      {"a", [{"href", href}], [text]} = link

      Floki.find_and_update(html, "h2:fl-contains('#{text}')", fn header ->
        {"h2", [{"id", String.replace(href, ~r/^#/, "")}]}
      end)
    end)
  end

  defp updated_html_tree(html) do
    links = parse_links(html)
    repos_info = AwesomeElixirWeb.GhReposInformerJob.run(links)

    Enum.reduce(repos_info, html, fn {url, data}, html ->
      Floki.traverse_and_update(html, fn
        {"li", [], [{"a", [{"href", ^url}], text}, desc]} ->
          %{stars: stars, last_commit: days} = data
          new_tag = {"span", [], ["#{stars} ⭐, 📅 #{days} days ago"]}
          {"li", [], [{"a", [{"href", url}], text}, desc, new_tag]}

        other -> other
      end)
    end)
  end

  defp parse_links(document) do
    # ["https://github.com/stocks29/dlist"]
    document
    |> Floki.find("li a[href^=\"https://github.com\"]")
    |> Enum.map(fn anchor ->
      {"a", [{_, href}], _} = anchor
      href
    end)
  end
end
