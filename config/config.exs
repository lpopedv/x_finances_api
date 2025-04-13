import Config

# ---------------------------
# Core (domain logic)
# ---------------------------
config :core,
  ecto_repos: [Core.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

config :core, Core.Mailer,
  adapter: Swoosh.Adapters.Local

# ---------------------------
# Frontend (LiveView)
# ---------------------------
config :frontend,
  generators: [timestamp_type: :utc_datetime, binary_id: true]

config :frontend, FrontendWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: FrontendWeb.ErrorHTML, json: FrontendWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Frontend.PubSub,
  live_view: [signing_salt: "1jrtqCLE"]

# Assets (esbuild & tailwind)
config :esbuild,
  version: "0.17.11",
  frontend: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/frontend/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.3",
  frontend: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/frontend/assets", __DIR__)
  ]

# ---------------------------
# Shared config
# ---------------------------
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Load env-specific overrides
import_config "#{config_env()}.exs"
