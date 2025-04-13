import Config

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "finances",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
