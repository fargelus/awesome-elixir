defmodule AwesomeElixirWeb.PageControllerTest do
  use AwesomeElixirWeb.ConnCase
  import AwesomeElixirWeb.SharedHelpers

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ html_template()
  end

  describe "GET /?popular" do
    test "has most popular lib", %{conn: conn} do
      conn = get(conn, "/", %{"popular" => ""})
      expected = "<span class=\"gh-repo-info gh-repo-stars\">#{Enum.max(repos_stars())} ⭐</span>"
      assert html_response(conn, 200) =~ expected
    end

    test "hasn't less popular lib", %{conn: conn} do
      conn = get(conn, "/", %{"popular" => ""})
      not_expected = "<span class=\"gh-repo-info gh-repo-stars\">#{Enum.min(repos_stars())} ⭐</span>"
      assert !(html_response(conn, 200) =~ not_expected)
    end
  end
end
