defmodule AwesomeElixirWeb.PageController do
  use AwesomeElixirWeb, :controller

  def index(conn, _params) do
    html = ConCache.get(
      AwesomeElixir.Const.Cache.name,
      AwesomeElixir.Const.Cache.template_key
    )

    html(conn, html)
  end
end
