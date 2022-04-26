import Config

config :filex, Filex.Repo,
database: "filex_test_repo",
username: "postgres",
password: "postgres",
hostname: "localhost",
pool: Ecto.Adapters.SQL.Sandbox
