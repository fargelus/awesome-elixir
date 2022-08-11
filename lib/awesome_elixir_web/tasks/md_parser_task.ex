defmodule AwesomeElixirWeb.MdParserTask do
  @moduledoc """
  Receive markdown as string, parse it to html
  and update it with GitHub repos info.
  """

  @github_host "https://github.com"
  @outdated_days 365

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

      Floki.find_and_update(html, "h2:fl-contains('#{text}')", fn _ ->
        {"h2", [{"id", String.replace(href, ~r/^#/, "")}]}
      end)
    end)
  end

  defp updated_html_tree(html) do
    links = parse_links(html)
    repos_info = AwesomeElixirWeb.GhReposInformerTask.run(links)

    Enum.reduce(repos_info, html, fn {url, data}, html ->
      %{stars: stars, last_commit: days} = data

      Floki.traverse_and_update(html, fn
        {"li", [], children} ->
          link = Enum.at(children, 0)
          case link do
            {"a", [{"href", ^url}], _} ->
              updated_children = [
                link,
                star_tag(stars),
                commit_tag(days),
                Enum.slice(children, 1..-1)
              ]

              {"li", list_item_attrs(days), List.flatten(updated_children)}

            _ -> {"li", [], children}
          end

        other -> other
      end)
    end)
  end

  defp star_tag(stars), do: {"span", [{"class", "gh-repo-info gh-repo-stars"}], ["#{stars} ⭐"]}
  defp commit_tag(days), do: {"span", [{"class", "gh-repo-info gh-repo-date"}], ["📅 #{days} days ago"]}

  defp list_item_attrs(days) do
    if days >= @outdated_days, do: [{"class", "outdated"}], else: []
  end

  defp parse_links(document) do
    document
    |> Floki.find("li a[href^=\"#{@github_host}\"]")
    |> Enum.map(fn anchor ->
      {"a", [{_, href}], _} = anchor
      href
    end)
  end
end
