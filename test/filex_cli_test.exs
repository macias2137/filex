defmodule FilexCLITest do
  @text_file_path "/Users/maciek/Desktop/projects/filex/lib/filex/text_file.txt"
  @pokemon_test_args ["Charmander", 4, true, 24]
  use ExUnit.Case, async: true
  doctest Filex.CLI

  import Filex.CLI
  import Filex.Factory
  alias Filex.Pokemon
  alias Filex.Repo
  alias Filex.Type

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

  describe "enter data into database" do
    setup do
     alias Ecto.Adapters.SQL.Sandbox
     :ok = Sandbox.checkout(Filex.Repo)
    end

    test "command line -p alias inserts struct into table 'pokemon'" do
      {:ok, pokemon} = parse_args(["-p"] ++ @pokemon_test_args)
      assert [pokemon.name, pokemon.pokedex, pokemon.basic, pokemon.type_id] == @pokemon_test_args
    end

    test "ensures name is unique" do
      parse_args(["-p"] ++ @pokemon_test_args)
      assert {:error, changeset} = parse_args(["-p", "Charmander", 6, false, 25])
    end
  end
end
