defmodule XFinancesWeb.Plugs.Auth do
  @moduledoc """
  Authentication plug for verifying and extracting user data from tokens.

  This plug:
  - Checks for the presence of a Bearer token in the Authorization header
  - Verifies the token's authenticity and expiration
  - Extracts and assigns the user data to the connection if valid
  - Returns a 401 Unauthorized response if the token is invalid or missing

  ## Usage
  Add this plug to your pipelines in the router:

      pipeline :auth do
        plug BrainWeb.Plugs.Auth
      end
  """

  import Plug.Conn
  alias XFinances.Auth.UserToken

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, data} <- UserToken.verify(token) do
      assign(conn, :current_user, data)
    else
      _reason ->
        conn
        |> put_status(:unauthorized)
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{message: "Unauthorized"}))
        |> halt()
    end
  end
end
