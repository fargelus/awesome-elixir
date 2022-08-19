defmodule AwesomeElixirWeb.RelevantLibsTask do
  @moduledoc """
  Returns 10 GitHub libs sorted by latest repo updates
  """

  @amount 10

  def run do
    doc = Floki.parse_document!(AwesomeElixir.Const.index_file_template())

    [
      {"h3", [], ["#{@amount} latest repos update"]},
      {"ul", [], sorted_items(doc)}
    ] |> Floki.raw_html
  end

  defp sorted_items(doc) do
    Floki.find(doc, "li")
    |> Enum.filter(fn item -> Floki.find(item, ".gh-repo-date") != [] end)
    |> Enum.sort_by(fn date_item ->
      [{_, _, [date_info]}] = Floki.find(date_item, ".gh-repo-date")

      Regex.run(~r/\d+/, date_info)
      |> Enum.at(0)
      |> String.to_integer
    end, :asc)
    |> Enum.take(@amount)
  end
end
