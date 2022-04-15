defmodule Filex.CLI do

  @text_file_path "/Users/maciek/Desktop/projects/filex/lib/filex/text_file.txt"

  def main(argv) do
    parse_args(argv)
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, strict: [read: :boolean, write: :boolean], aliases: [r: :read, w: :write])

    case parse do
     {[read: true], _, _} -> read_file()
     {[write: true], user_input, _} -> write_to_file(user_input)
    end
  end

  def read_file do
    {:ok, contents} = File.read(@text_file_path)
    IO.inspect(contents, label: "File contents")
  end

  def write_to_file(input) do
    File.write(@text_file_path, "\n#{input}", [:append])
  end
end
