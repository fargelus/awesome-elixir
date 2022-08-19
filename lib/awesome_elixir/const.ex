defmodule AwesomeElixir.Const do
  def index_file_path do
    Application.app_dir(:awesome_elixir, "priv/static/index.html")
  end

  def index_file_template do
    File.read!(index_file_path())
  end
end
