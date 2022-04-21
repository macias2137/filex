defmodule Filex.Repo.Migrations.AddTypeReferenceToPokemon do
  use Ecto.Migration

  def change do
    alter table("pokemon") do
      add :type, references(:types)
    end
  end
end
