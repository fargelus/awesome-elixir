defmodule AwesomeElixirWeb.PageController do
  use AwesomeElixirWeb, :controller

  def index(conn, _params) do
    render(
      conn,
      "index.html",
      content: File.read!(AwesomeElixir.Const.index_file_path())
    )
  end
end
