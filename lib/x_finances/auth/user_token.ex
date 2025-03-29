defmodule XFinances.Auth.UserToken do
  @moduledoc """
  Token handling module for authentication purposes.

  This module provides functions for signing and verifying Phoenix tokens
  used in the authentication system.

  Tokens are signed with a secret salt and have a maximum age of 24 hours.
  """

  alias XFinancesWeb.Endpoint
  alias Phoenix.Token

  # TODO: add env var
  @token_salt "x_finances_token_salt"

  @doc """
  Signs the given token data into a Phoenix token.

  ## Parameters
    - token_data: A map containing the data to be encoded in the token

  ## Returns
    A signed token string

  ## Examples
      iex> Token.sign(%{user_id: 1, roles: [:admin]})
      "aGVsbG8gd29ybGQ..."
  """
  @spec sign(map()) :: String.t()
  def sign(token_data), do: Token.sign(Endpoint, @token_salt, token_data)

  @doc """
  Verifies the authenticity and validity of a Phoenix token.

  ## Parameters
    - token: The token string to verify

  ## Returns
    - `{:ok, claims}` - If the token is valid and hasn't expired
    - `{:error, reason}` - If the token is invalid or expired

  ## Examples
      iex> Token.verify("aGVsbG8gd29ybGQ...")
      {:ok, %{user_id: 1, roles: [:admin]}}

      iex> Token.verify("invalid_token")
      {:error, :invalid}
  """
  @spec verify(binary()) :: {:error, :expired | :invalid | :missing} | {:ok, map()}
  def verify(token), do: Token.verify(Endpoint, @token_salt, token, max_age: 86_400)
end
