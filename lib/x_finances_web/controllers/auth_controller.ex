defmodule XFinancesWeb.AuthController do
  use XFinancesWeb, :controller

  alias XFinances.Auth.UserToken
  alias XFinances.Users
  alias XFinances.Schemas.User

  def authenticate(conn, %{"email" => email, "password" => password}) do
    case Users.authenticate(%{"email" => email, "password" => password}) do
      {:ok, %User{} = user} ->
        token_data =
          %{
            id: user.id,
            email: user.email,
            full_name: user.full_name,
            base_income: user.base_income
          }

        token = UserToken.sign(token_data)

        conn
        |> put_status(:ok)
        |> render(:authenticate, token: token)

      {:error, :invalid_credentials} ->
        conn
        |> put_status(:unauthorized)
        |> render(:authenticate, error: :invalid_credentials)
    end
  end

  def authenticate(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> render(:authenticate, error: :invalid_parameters)
  end
end
