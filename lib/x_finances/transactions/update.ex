defmodule XFinances.Transactions.Update do
  alias XFinances.Transactions.Transaction
  alias XFinances.Repo

  def call(%{"id" => id} = params) do
    case Repo.get(Transaction, id) do
      nil -> {:error, :not_found}
      transaction -> update(transaction, params)
    end
  end

  def update(transaction, params) do
    transaction
    |> Transaction.changeset(params)
    |> Repo.update()
  end
end
