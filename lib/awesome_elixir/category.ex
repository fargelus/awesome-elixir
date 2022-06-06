defmodule AwesomeElixir.Category do
  use Ecto.Schema

  schema "categories" do
    field :name, :string
    field :description, :string
    has_many :libraries, AwesomeElixir.Library
  end
end
