defmodule FilexCLITest do

  @text_file_path "/Users/maciek/Desktop/projects/filex/lib/filex/text_file.txt"

  use ExUnit.Case, async: true
  doctest Filex.CLI

  import Filex.CLI
  import Filex.Factory
  alias Filex.Pokemon
  alias Filex.Repo
  alias Filex.Type

  setup do
    alias Ecto.Adapters.SQL.Sandbox
    Sandbox.mode(Filex.Repo, :manual)
    :ok = Sandbox.checkout(Filex.Repo)
  end

  describe "read contents from text file" do
    setup do
      File.rm(@text_file_path)
      File.write(@text_file_path, "12345")
    end

    test "command line --read option and -r alias allow for reading from text file" do
      assert parse_args(["--read"]) == "12345"
      assert parse_args(["-r"]) == "12345"
    end

    test "command line --read option and -r alias with additional argument allow for reading from text file" do
      assert parse_args(["--read", "some argument"]) == "12345"
      assert parse_args(["-r", "some argument"]) == "12345"
    end

    test "read_file function outputs text file contents" do
      assert read_file("some label") == "12345"
    end
  end

  describe "write user input to file" do
    setup do
      File.rm(@text_file_path)
      File.touch(@text_file_path)
    end

    test "command line --write option allows for writing to text file" do
      refute parse_args(["--read"]) =~ "some argument"
      parse_args(["--write", "some argument"])
      assert parse_args(["--read"]) =~ "some argument"
    end

    test "command line -w alias allows for writing to text file" do
      refute parse_args(["--read"]) =~ "some argument"
      parse_args(["-w", "some argument"])
      assert parse_args(["--read"]) =~ "some argument"
    end

    test "write_to_file function adds newline at the end of user input" do
      parse_args(["--write", "12345"])
      assert parse_args(["--read"]) == "12345" <> "\n"
    end

    test "write_to_file function appends user input to previous file content" do
      File.write(@text_file_path, "12345")
      assert parse_args(["--write", "67890"]) == "1234567890" <> "\n"
    end
  end

  describe "delete content from file" do
    setup do
      File.rm(@text_file_path)
      File.write(@text_file_path, "123 456\n")
    end

    test "command line --delete option allows for deleting items from text file" do
      assert parse_args(["--delete", "1"]) == "23 456\n"
    end

    test "command line -d alias allows for deleting items from text file" do
      assert parse_args(["-d", "1"]) == "23 456\n"
    end

    test "delete_from_file function removes space if it appears directly after user input in text file" do
      assert parse_args(["--delete", "123"]) == "456\n"
    end

    test "delete_from_file function removes free-standing newlines" do
      assert parse_args(["--delete", "456"]) == "123 "
    end
  end

  describe "database" do

    @pokemon_test_args ["Charmander", 4, true]

    setup do
      %{type: insert(:type)}
    end

    test "command line -p alias inserts struct into table 'pokemon'", %{type: type} do
      {:ok, pokemon} = parse_args(["-p"] ++ @pokemon_test_args ++ [type.id])
      assert [pokemon.name, pokemon.pokedex, pokemon.basic, pokemon.type_id] == @pokemon_test_args ++ [type.id]
    end

    test "inserts struct if name in Pokemon is unique, returns error otherwise", %{type: type} do
      assert {:ok, pokemon} = parse_args(["-p"] ++ @pokemon_test_args ++ [type.id])
      assert {:error, changeset} = parse_args(["-p", "Charmander", 6, false] ++ [type.id])
    end

    test "inserts struct if pokedex in Pokemon is unique, returns error otherwise", %{type: type} do
      assert {:ok, pokemon} = parse_args(["-p"] ++ @pokemon_test_args ++ [type.id])
      assert {:error, changeset} = parse_args(["-p", "Bulbasaur", 4, true] ++ [type.id])
    end

    test "inserts struct if pokedex is an integer between 1 and 151, returns error otherwise", %{type: type} do
      assert {:ok, pokemon} = parse_args(["-p"] ++ @pokemon_test_args ++ [type.id])
      assert {:error, changeset} = parse_args(["-p", "Squirtle", 161, true, 1])
      assert {:error, changeset} = parse_args(["-p", "Bulbasaur", 0.66, true, 1])
      assert {:error, changeset} = parse_args(["-p", "Charmeleon", -99, false, 1])
      assert {:error, changeset} = parse_args(["-p", "Ivysaur", -2.37, false, 1])
    end

    test "inserts struct if name in Type is unique, returns error otherwise" do
      assert {:ok, type} = parse_args(["-t", "rock"])
      assert {:error, changeset} = parse_args(["-t", "rock"])
      assert {:ok, type} = parse_args(["-t", "dragon"])
      assert {:error, changeset} = parse_args(["-t", "dragon"])
    end

    test "function get_all_pokemon_by_type fetches all pokemon of given type", %{type: type} do
      insert(:pokemon, name: "Charmander", pokedex: 4, type: type)
      insert(:pokemon, name: "Charmeleon", pokedex: 5, type: type)
      insert(:pokemon, name: "Charizard", pokedex: 6, type: type)

      pokemon_list = get_all_pokemon_by_type(type.name)
      assert Enum.map(pokemon_list, &(Map.get(&1, :name))) == ["Charmander", "Charmeleon", "Charizard"]
    end
  end
end
