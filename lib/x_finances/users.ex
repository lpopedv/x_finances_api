defmodule XFinances.Users do
  alias XFinances.Auth.Authenticate
  alias XFinances.Users.Create
  alias XFinances.Users.Delete
  alias XFinances.Users.Get
  alias XFinances.Users.Update

  defdelegate authenticate(email), to: Authenticate, as: :call
  defdelegate create(params), to: Create, as: :call
  defdelegate delete(id), to: Delete, as: :call
  defdelegate get_all(), to: Get, as: :all
  defdelegate get_by_id(id), to: Get, as: :by_id
  defdelegate get_by_email(email), to: Get, as: :by_email
  defdelegate update(params), to: Update, as: :call
end
