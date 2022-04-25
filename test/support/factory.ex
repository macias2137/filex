defmodule Filex.Factory do
  use ExMachina.Ecto, repo: Filex.Repo

  def pokemon_factory do
    %Filex.Pokemon{
     name: "sample_pokemon",
     pokedex: 1,
     basic: true,
     type: build(:type)
    }
  end

  def type_factory do
    %Filex.Type{
      name: "sample_type"
    }
  end
end
