defmodule PhoenixAsh.Account.Sender.SendPasswordResetEmail do
  @moduledoc """
  Sends a password reset email
  """

  use AshAuthentication.Sender
  use PhoenixAshWeb, :verified_routes

  @impl AshAuthentication.Sender
  def send(user, token, _) do
    PhoenixAsh.Account.Email.deliver_reset_password_instructions(
      user,
      url(~p"/password-reset/#{token}")
    )
  end
end
