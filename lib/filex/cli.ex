defmodule Filex.CLI do

  @text_file_path "/Users/maciek/Desktop/projects/filex/lib/filex/text_file.txt"

  def main(argv) do
    parse_args(argv)
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv,
    strict: [read: :boolean, write: :boolean, delete: :boolean],
    aliases: [r: :read, w: :write, d: :delete])

    case parse do
     {[read: true], _, _} -> read_file("File contents")
     {[write: true], user_input, _} -> write_to_file(user_input)
     {[delete: true], user_input, _} -> delete_from_file(user_input)
    end
  end

  def read_file(label) do
    {:ok, contents} = File.read(@text_file_path)
    IO.inspect(contents, label: label)
  end

  def write_to_file(input) do
    File.write(@text_file_path, "\n#{input}", [:append])
  end

  def delete_from_file(input) do
    new_contents =
    File.stream!(@text_file_path)
    |> Stream.map(&String.split(&1, input, trim: true))
    |> Enum.to_list()
    |> List.flatten()
    |> List.to_string()
    File.write(@text_file_path, new_contents)
    read_file("New file contents")
  end
end
