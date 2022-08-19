defmodule AwesomeElixirWeb.SharedHelpers do
  def html_template do
    AwesomeElixir.Const.index_file_template()
  end

  def repos_stars do
    Floki.find(html_template(), ".gh-repo-stars")
    |> Enum.map(fn node ->
      {star, " ⭐"} = Integer.parse(Floki.text(node))
      star
    end)
  end

  def repos_dates do
    Floki.find(html_template(), ".gh-repo-date")
    |> Enum.map(fn node ->
      {_, _, [date_info]} = node
      Regex.run(~r/\d+/, date_info) |> Enum.at(0)
    end)
  end

  def build_star_html(stars) do
    "<span class=\"gh-repo-info gh-repo-stars\">#{stars} ⭐</span>"
  end

  def build_date_html(date) do
    "<span class=\"gh-repo-info gh-repo-date\">📅 #{date} days ago</span>"
  end
end
