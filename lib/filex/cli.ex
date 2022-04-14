defmodule Filex.CLI do
  def run(argv) do
    parse_args(argv)
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, strict: [r: :boolean
    # ,w: :boolean, d: :boolean
    ], aliases: [r: :read])
    # , w: :write, d: delete

    case parse do
      ([read: true], _) -> true
    end
  end
end
