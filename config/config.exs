import Config

config :filex, Filex.Test.Repo,
  database: "filex_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :filex, Filex.Repo,
  database: "filex_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :filex, ecto_repos: [Filex.Repo]

import_config "#{Mix.env()}.exs"
