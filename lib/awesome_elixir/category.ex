defmodule AwesomeElixir.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    field :description, :string
    has_many :libraries, AwesomeElixir.Library
  end

  def changeset(category, params \\ %{}) do
    category
    |> cast(params, [:name, :description])
    |> cast_assoc(:libraries)
    |> validate_required(:name)
  end
end
