import Config

config :filex, Filex.Repo,
  database: "filex_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :filex, ecto_repos: [Filex.Repo]

config :filex, Filex.Repo, pool: Ecto.Adapters.SQL.Sandbox
