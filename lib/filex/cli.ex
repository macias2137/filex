defmodule Filex.CLI do

  @text_file_path "/Users/maciek/Desktop/projects/filex/lib/filex/text_file.txt"
  alias Filex.Pokemon
  alias Filex.Type
  alias Filex.Repo
  import Ecto.Query

  def main(argv) do
    parse_args(argv)
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv,
    strict: [read: :boolean, write: :boolean, delete: :boolean, pokemon: :boolean, type: :boolean],
    aliases: [r: :read, w: :write, d: :delete, p: :pokemon, t: :type])

    case parse do
     {[read: true], _, _} -> read_file("File contents")
     {[write: true], user_input, _} -> write_to_file(user_input)
     {[delete: true], user_input, _} -> delete_from_file(user_input)
     {[pokemon: true], [name, pokedex, basic, type_id], _} -> add_pokemon(name, pokedex, basic, type_id)
     {[type: true], [name], _} -> add_type(name)
    end
  end

  def read_file(label) do
    {:ok, contents} = File.read(@text_file_path)
    IO.write(label <> ":\n" <> contents)
    contents
  end

  def write_to_file(input) do
    File.write(@text_file_path, "#{input}\n", [:append])
    read_file("New file contents")
  end

  def delete_from_file(input) do
    new_contents =
    @text_file_path
    |> File.stream!()
    |> Stream.map(&String.split(&1, [List.to_string(input), List.to_string(input) <> " "], trim: true))
    |> Enum.to_list()
    |> List.flatten()
    |> Enum.reject(&(&1 == "\n"))
    |> List.to_string()
    File.write(@text_file_path, new_contents)
    read_file("New file contents")
  end

  def add_pokemon(name, pokedex, basic, type_id) do
    changeset = Pokemon.changeset(%Filex.Pokemon{}, %{name: name, pokedex: pokedex, basic: basic, type_id: type_id})
    Filex.Repo.insert(changeset)
  end

  def add_type(name) do
    changeset = Type.changeset(%Filex.Type{}, %{name: name})
    Filex.Repo.insert(changeset)
  end

  def get_all_pokemon_by_type(type) do
    # query = from t in Type, where: t.name == ^type
    # query = from p in Pokemon, join: q in subquery(query), on: p.type_id == q.id
    query = from p in Pokemon, join: t in assoc(p, :type), where: t.name == ^type
    Repo.all(query)
  end
end
