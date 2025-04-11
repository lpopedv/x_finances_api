defmodule XFinances.Transactions.CrudOperations do
  alias XFinances.Repo
  alias XFinances.Schemas.Transaction

  def create(new_transaction_params) do
    new_transaction_params
    |> Transaction.changeset()
    |> Repo.insert()
    |> case do
      {:ok, transaction} -> {:ok, Repo.preload(transaction, :category)}
      error -> error
    end
  end

  def update(transaction_id, new_transaction_params) do
    case Repo.get(Transaction, transaction_id) do
      nil ->
        {:error, :not_found}

      transaction ->
        transaction
        |> Transaction.changeset(new_transaction_params)
        |> Repo.update()
        |> case do
          {:ok, transaction} -> {:ok, Repo.preload(transaction, :category)}
          error -> error
        end
    end
  end

  def delete(id) do
    case Repo.get(Transaction, id) do
      nil ->
        {:error, :not_found}

      transaction ->
        transaction_with_category = Repo.preload(transaction, :category)

        case Repo.delete(transaction_with_category) do
          {:ok, deleted_transaction} ->
            {:ok, deleted_transaction}

          error ->
            error
        end
    end
  end

  def list, do: Transaction |> Repo.all() |> Repo.preload(:category)

  def show(id) do
    case Repo.get(Transaction, id) do
      nil -> {:error, :not_found}
      transaction -> {:ok, Repo.preload(transaction, :category)}
    end
  end
end
