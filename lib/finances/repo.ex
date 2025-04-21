defmodule Finances.Repo do
  use Ecto.Repo,
    otp_app: :finances,
    adapter: Ecto.Adapters.Postgres
end
