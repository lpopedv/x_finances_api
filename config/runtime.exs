import Config

# Enable Phoenix server if PHX_SERVER=true is set
if System.get_env("PHX_SERVER") do
  config :frontend, FrontendWeb.Endpoint, server: true
  config :core, CoreWeb.Endpoint, server: true
end

if config_env() == :prod do
  ## FRONTEND CONFIGURATION

  frontend_secret_key_base =
    System.get_env("FRONTEND_SECRET_KEY_BASE") ||
      raise """
      environment variable FRONTEND_SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  frontend_host = System.get_env("FRONTEND_PHOX_HOST") || "frontend.example.com"
  frontend_port = String.to_integer(System.get_env("FRONTEND_PORT") || "4000")

  config :frontend, :dns_cluster_query, System.get_env("FRONTEND_DNS_CLUSTER_QUERY")

  config :frontend, FrontendWeb.Endpoint,
    url: [host: frontend_host, port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: frontend_port],
    secret_key_base: frontend_secret_key_base

  ## CORE CONFIGURATION

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :core, Core.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  core_secret_key_base =
    System.get_env("CORE_SECRET_KEY_BASE") ||
      raise """
      environment variable CORE_SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  core_host = System.get_env("CORE_PHX_HOST") || "core.example.com"
  core_port = String.to_integer(System.get_env("CORE_PORT") || "4000")

  config :core, :dns_cluster_query, System.get_env("CORE_DNS_CLUSTER_QUERY")

  config :core, CoreWeb.Endpoint,
    url: [host: core_host, port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: core_port],
    secret_key_base: core_secret_key_base

  # Mailer (optional)
  if System.get_env("MAILGUN_API_KEY") do
    config :core, Core.Mailer,
      adapter: Swoosh.Adapters.Mailgun,
      api_key: System.get_env("MAILGUN_API_KEY"),
      domain: System.get_env("MAILGUN_DOMAIN")

    config :swoosh, :api_client, Swoosh.ApiClient.Finch
  end
end
