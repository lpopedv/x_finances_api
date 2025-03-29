defmodule XFinancesWeb.AuthJSON do
  def authenticate(%{token: token}), do: %{bearer: token}

  def authenticate(%{error: :invalid_credentials}),
    do: %{
      message: "Invalid e-mail or password"
    }

  def authenticate(%{error: :invalid_parameters}),
    do: %{
      message: "Invalid parameters"
    }
end
