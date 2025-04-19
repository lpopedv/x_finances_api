defmodule Core.User.Services.AuthService do
  alias Core.User.Services.CrudOperationsService
  alias Argon2

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
