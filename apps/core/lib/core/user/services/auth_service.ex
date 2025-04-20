defmodule Core.User.Services.AuthService do
  @moduledoc """
  Provides authentication services for user credentials verification.

  Handles password hashing and validation using Argon2.
  """

  alias Core.User.Services.CrudOperationsService
  alias Argon2

  @doc """
  Verifies user credentials against stored hashed password.

  ## Parameters
    - email: User's email address
    - password: User's password attempt

  ## Returns
    - `{:ok, User.t}` if credentials are valid
    - `{:error, :invalid_credentials}` for invalid email/password
  """
  @spec verify_and_get_user(String.t(), String.t()) ::
          {:ok, Core.Schemas.User.t()} | {:error, :invalid_credentials}
  def verify_and_get_user(email, password) do
    with {:ok, user} <- CrudOperationsService.get_by_email(email),
         true <- Argon2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      _ ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}
    end
  end
end
