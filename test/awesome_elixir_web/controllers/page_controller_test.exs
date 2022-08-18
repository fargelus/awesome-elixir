defmodule AwesomeElixirWeb.PageControllerTest do
  use AwesomeElixirWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    content = File.read!(AwesomeElixir.Const.index_file_path())
    assert html_response(conn, 200) =~ content
  end
end
