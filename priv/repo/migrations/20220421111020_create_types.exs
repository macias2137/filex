defmodule Filex.Repo.Migrations.CreateTypes do
  use Ecto.Migration

  def change do
    create table(:types) do
      add :name, :string, null: false
    end

    create unique_index(:types, [:name])
  end
end
