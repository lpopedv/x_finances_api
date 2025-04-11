defmodule XFinances.Users do
  alias XFinances.Auth.Authenticate
  alias XFinances.Users.CrudOperations

  defdelegate authenticate(email), to: Authenticate, as: :call
  defdelegate create(params), to: CrudOperations
  defdelegate delete(id), to: CrudOperations
  defdelegate list(), to: CrudOperations
  defdelegate show(id), to: CrudOperations
  defdelegate get_by_email(email), to: CrudOperations
  defdelegate update(user_id, params), to: CrudOperations
end
