defmodule AwesomeElixir.Repo.Migrations.CreateLibraries do
  use Ecto.Migration

  def change do
    create table(:libraries) do
      add :title, :string
      add :description, :text
      add :url, :string
      add :stars, :integer
      add :days_after_last_commit, :integer
      add :category_id, references(:categories)
    end
  end
end
