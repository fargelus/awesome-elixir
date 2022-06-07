defmodule AwesomeElixir.Repo.Migrations.CreateLibraries do
  use Ecto.Migration

  def change do
    create table(:libraries) do
      add :title, :string, null: false
      add :description, :text
      add :url, :string, null: false
      add :stars, :integer
      add :days_after_last_commit, :integer
      add :category_id, references(:categories), null: false
    end
  end
end
