defmodule AwesomeElixir.Const do
  def index_file_path do
    Application.app_dir(:awesome_elixir, "priv/static/index.html")
  end
end
