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
      assert html_response(conn, 200) =~ build_star_html(Enum.max(repos_stars()))
    end

    test "hasn't less popular lib", %{conn: conn} do
      conn = get(conn, "/", %{"popular" => ""})
      assert !(
        html_response(conn, 200) =~ build_star_html(Enum.min(repos_stars()))
      )
    end
  end

  describe "GET /?relevant" do
    test "has most relevant lib", %{conn: conn} do
      conn = get(conn, "/", %{"relevant" => ""})
      assert html_response(conn, 200) =~ build_date_html(Enum.min(repos_dates()))
    end

    test "hasn't very old lib", %{conn: conn} do
      conn = get(conn, "/", %{"relevant" => ""})
      assert !(
        html_response(conn, 200) =~ build_date_html(Enum.max(repos_dates()))
      )
    end
  end
end
