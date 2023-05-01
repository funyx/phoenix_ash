import Config

config :ash, :use_all_identities_in_manage_relationship?, false

config :phoenix_ash,
  ecto_repos: [PhoenixAsh.Repo]

config :phoenix_ash,
  ash_apis: [PhoenixAsh.Blog]

config :phoenix_ash, PhoenixAshWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: PhoenixAshWeb.ErrorHTML, json: PhoenixAshWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PhoenixAsh.PubSub,
  live_view: [signing_salt: "aBle/H8z"]

config :phoenix_ash, PhoenixAsh.Mailer, adapter: Swoosh.Adapters.Local

config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
