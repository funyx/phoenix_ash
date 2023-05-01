defmodule PhoenixAsh.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PhoenixAshWeb.Telemetry,
      # Start the Ecto repository
      PhoenixAsh.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhoenixAsh.PubSub},
      # Start Finch
      {Finch, name: PhoenixAsh.Finch},
      # Start the Endpoint (http/https)
      PhoenixAshWeb.Endpoint
      # Start a worker by calling: PhoenixAsh.Worker.start_link(arg)
      # {PhoenixAsh.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixAsh.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixAshWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
