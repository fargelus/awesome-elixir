defmodule AwesomeElixir.Library do
  use Ecto.Schema
  import Ecto.Changeset

  schema "libraries" do
    field :title, :string
    field :description, :string
    field :url, :string
    field :stars, :integer
    field :days_after_last_commit, :integer
    belongs_to :category, AwesomeElixir.Category
  end

  def changeset(lib, params \\ %{}) do
    lib
    |> cast(params, [
      :title,
      :description,
      :url,
      :stars,
      :days_after_last_commit
    ])
    |> cast_assoc(:category)
    |> validate_required([:title, :url, :category])
    |> unique_constraint(:url)
    |> validate_number(:stars, greater_than_or_equal_to: 0)
    |> validate_number(:days_after_last_commit, greater_than_or_equal_to: 0)
    |> validate_format(:url, ~r/^https:\/\/.+/)
  end
end
