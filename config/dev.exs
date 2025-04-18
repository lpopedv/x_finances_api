import Config

# ---------------------------
# Frontend (LiveView)
# ---------------------------
config :frontend, FrontendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "o/2GJKuTwshaXwZQ06r7xm4oxP68pdMPeaV2B9Bp7B4oz56cbIVdwA6+T3d4/q1l",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:frontend, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:frontend, ~w(--watch)]}
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/frontend_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev-only routes (dashboard, mailbox, etc.)
config :frontend, dev_routes: true

# ---------------------------
# Core (Domain logic - Repo)
# ---------------------------
config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "finances",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# ---------------------------
# Dev environment preferences
# ---------------------------
config :logger, :console,
  format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true
