defmodule PhoenixAsh.Account do
  use Ash.Api

  resources do
    registry(PhoenixAsh.Account.Registry)
  end
end
