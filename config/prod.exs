import Config

# ---------------------------
# Frontend (LiveView)
# ---------------------------
config :frontend, FrontendWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

# ---------------------------
# Core (Domain logic)
# ---------------------------
# Caso o Core também exponha um endpoint (ex: API separada), descomente abaixo:
# config :core, CoreWeb.Endpoint,
#   cache_static_manifest: "priv/static/cache_manifest.json"

# ---------------------------
# Swoosh (Email)
# ---------------------------
config :swoosh,
  api_client: Swoosh.ApiClient.Finch,
  finch_name: Core.Finch,
  local: false

# ---------------------------
# Logger
# ---------------------------
config :logger, level: :info

# ---------------------------
# Observação
# ---------------------------
# Runtime configuration (como porta, banco, etc) deve estar no:
# `config/runtime.exs`
