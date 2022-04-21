defmodule Filex.Pokemon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pokemon" do
    field :name, :string
    field :pokedex, :integer
    field :basic, :boolean
  end

  def changeset(pokemon, params \\ %{}) do
    pokemon
    |> cast(params, [:name, :pokedex, :basic])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
