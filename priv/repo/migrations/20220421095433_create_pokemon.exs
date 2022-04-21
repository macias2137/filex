defmodule Filex.Repo.Migrations.CreatePokemon do
  use Ecto.Migration

  def change do
    create table(:pokemon) do
      add :name, :string
      add :pokedex, :integer
      add :basic, :boolean
      timestamps()
    end
  end
end
