defmodule Filex.Repo do
  use Ecto.Repo,
    otp_app: :filex,
    adapter: Ecto.Adapters.Postgres
end
