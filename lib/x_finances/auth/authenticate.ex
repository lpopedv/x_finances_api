defmodule XFinances.Auth.Authenticate do
  @moduledoc """
  Authentication module responsible for validating user credentials.

  This module provides functionality to authenticate users by verifying their email
  and password credentials against stored user data.
  """

  alias XFinances.Users
  alias XFinances.Users.User

  @doc """
  Authenticates a user with the given credentials.

  ## Parameters
    * credentials - A map containing:
      * `"email"` - The user email address
      * `"password"` - The user password

  ## Returns
    * `{:ok, user}` - If credentials are valid
    * `{:error, :invalid_credentials}` - If email doesn't exist or password is incorrect
  """
  @spec call(map()) :: {:ok, User.t()} | {:error, :invalid_credentials}
  def call(%{"email" => email, "password" => password}) do
    case Users.get_by_email(email) do
      {:ok, user} -> verify_password(user, password)
      {:error, :not_found} -> {:error, :invalid_credentials}
    end
  end

  @doc false
  @spec verify_password(User.t(), String.t()) :: {:ok, User.t()} | {:error, :invalid_credentials}
  defp verify_password(user, password) do
    case Argon2.verify_pass(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, :invalid_credentials}
    end
  end
end
