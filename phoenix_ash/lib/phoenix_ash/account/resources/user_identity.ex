defmodule PhoenixAsh.Account.UserIdentity do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.UserIdentity]

  user_identity do
    api(PhoenixAsh.Account)
    user_resource(PhoenixAsh.Account.User)
  end

  postgres do
    table("user_identity")
    repo(PhoenixAsh.Repo)
  end
end
