import Config

config :filex, ecto_repos: [Filex.Repo]

import_config "#{Mix.env()}.exs"
