defmodule XFinances.Transactions.Create do
  alias XFinances.Repo
  alias XFinances.Transactions.Transaction

  def call(params) do
    params
    |> Transaction.changeset()
    |> Repo.insert()
  end
end
