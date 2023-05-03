defmodule PhoenixAsh.Account.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  token do
    api(PhoenixAsh.Account)
  end

  postgres do
    table("token")
    repo(PhoenixAsh.Repo)
  end

  # If using policies, add the following bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
