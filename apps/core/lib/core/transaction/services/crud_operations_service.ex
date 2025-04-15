defmodule Core.Transaction.Services.CrudOperationsService do
  alias Core.Schemas.Transaction
  alias Core.Repo

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

  def delete(transaction_id) do
    case Repo.get(Transaction, transaction_id) do
      nil -> {:error, :not_found}
      transaction -> Repo.delete(transaction)
    end
  end

  def list, do: Transaction |> Repo.all() |> Repo.preload([:category, :user])

  def show(id) do
    case Repo.get(Transaction, id) do
      nil -> {:error, :not_found}
      transaction -> {:ok, Repo.preload(transaction, [:category, :user])}
    end
  end
end
