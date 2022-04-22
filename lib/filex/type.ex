defmodule Filex.Type do
  use Ecto.Schema
  import Ecto.Changeset

  schema "types" do
    field :name, :string
  end

  def changeset(type, params \\ %{}) do
    type
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
