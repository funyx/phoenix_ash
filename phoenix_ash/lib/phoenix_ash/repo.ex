defmodule PhoenixAsh.Repo do
  use AshPostgres.Repo,
    # ,
    otp_app: :phoenix_ash

  # adapter: Ecto.Adapters.Postgres
  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
