defmodule AwesomeElixir.Library do
  use Ecto.Schema

  schema "libraries" do
    field :title, :string
    field :description, :string
    field :url, :string
    field :stars, :integer
    field :days_after_last_commit, :integer
    belongs_to :category, AwesomeElixir.Category
  end
end
