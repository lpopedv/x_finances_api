defmodule XFinances.Transactions.CrudOperations do
  alias XFinances.Repo
  alias XFinances.Schemas.Transaction

  def create(new_transaction_params) do
    new_transaction_params
    |> Transaction.changeset()
    |> Repo.insert()
  end

  def update(transaction_id, new_transaction_params) do
    case Repo.get(Transaction, transaction_id) do
      nil ->
        {:error, :not_found}

      transaction ->
        transaction
        |> Transaction.changeset(new_transaction_params)
        |> Repo.update()
    end
  end

  def delete(id) do
    case Repo.get(Transaction, id) do
      nil -> {:error, :not_found}
      transaction -> Repo.delete(transaction)
    end
  end

  def list, do: Repo.all(Transaction)

  def show(id) do
    case Repo.get(Transaction, id) do
      nil -> {:error, :not_found}
      transaction -> Repo.delete(transaction)
    end
  end
end
