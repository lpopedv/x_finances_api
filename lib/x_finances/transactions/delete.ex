defmodule XFinances.Transactions.Delete do
  alias XFinances.Repo
  alias XFinances.Transactions.Transaction

  def call(id) do
    case Repo.get(Transaction, id) do
      nil -> {:error, :not_found}
      transaction -> Repo.delete(transaction)
    end
  end
end
