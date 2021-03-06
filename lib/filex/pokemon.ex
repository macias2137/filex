defmodule Filex.Pokemon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pokemon" do
    field :name, :string
    field :pokedex, :integer
    field :basic, :boolean
    belongs_to :type, Filex.Type
  end

  def changeset(pokemon, params \\ %{}) do
    pokemon
    |> cast(params, [:name, :pokedex, :basic, :type_id])
    |> validate_required([:name])
    |> validate_inclusion(:pokedex, 1..151)
    |> unique_constraint(:pokedex)
    |> unique_constraint(:name)
  end

end
