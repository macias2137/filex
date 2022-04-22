defmodule Filex.Repo.Migrations.CreatePokemon do
  use Ecto.Migration

  def change do
    create table(:pokemon) do
        add :name, :string, null: false
        add :pokedex, :integer
        add :basic, :boolean
    end

    create unique_index(:pokemon, [:name])
    create unique_index(:pokemon, [:pokedex])
  end
end
