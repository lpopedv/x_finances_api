defmodule XFinances.Repo do
  use Ecto.Repo,
    otp_app: :x_finances,
    adapter: Ecto.Adapters.Postgres
end
