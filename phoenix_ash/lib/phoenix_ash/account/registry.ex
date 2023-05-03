defmodule PhoenixAsh.Account.Registry do
  use Ash.Registry, extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry(PhoenixAsh.Account.User)
    entry(PhoenixAsh.Account.Token)
    entry(PhoenixAsh.Account.UserIdentity)
  end
end
