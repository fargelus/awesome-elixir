defmodule AwesomeElixirWeb.PageController do
  use AwesomeElixirWeb, :controller

  def index(conn, %{"min-stars" => stars}) do
    stars = String.to_integer(stars)
    render(
      conn,
      "index.html",
      content: AwesomeElixirWeb.LibraryStarsFilterTask.run(stars)
    )
  end

  def index(conn, %{"relevant" => ""}) do
    render(
      conn,
      "index.html",
      content: AwesomeElixirWeb.RelevantLibsTask.run
    )
  end

  def index(conn, %{"popular" => ""}) do
    render(
      conn,
      "index.html",
      content: AwesomeElixirWeb.PopularLibsTask.run
    )
  end

  def index(conn, _params) do
    render(
      conn,
      "index.html",
      content: File.read!(AwesomeElixir.Const.index_file_path())
    )
  end
end
