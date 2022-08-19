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
end
