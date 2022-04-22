defmodule Filex.CLI do
  import Filex.Pokemon
  @text_file_path "/Users/maciek/Desktop/projects/filex/lib/filex/text_file.txt"

  def main(argv) do
    parse_args(argv)
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv,
    strict: [read: :boolean, write: :boolean, delete: :boolean, pokemon: :boolean],
    aliases: [r: :read, w: :write, d: :delete, p: :pokemon])

    case parse do
     {[read: true], _, _} -> read_file("File contents")
     {[write: true], user_input, _} -> write_to_file(user_input)
     {[delete: true], user_input, _} -> delete_from_file(user_input)
     {[pokemon: true], [name, pokedex, type], _} -> add_pokemon(name, pokedex, type)
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

  def add_pokemon(name, pokedex, basic) do
    changeset = changeset(%Filex.Pokemon{}, %{name: name, pokedex: pokedex, basic: basic})
    Filex.Repo.insert(changeset)
  end
end
