defmodule XFinancesWeb.TransactionsJSON do
  alias XFinances.Schemas.Transaction

  def index(%{transactions: transactions}) do
    %{
      transactions: Enum.map(transactions, &transaction_to_map/1)
    }
  end

  def create(%{transaction: transaction}) do
    %{
      message: "Transação criada com sucesso",
      new_transaction: transaction_to_map(transaction)
    }
  end

  def update(%{transaction: transaction}) do
    %{
      message: "Transação atualizada com sucesso",
      updated_transaction: transaction_to_map(transaction)
    }
  end

  def show(%{transaction: transaction}) do
    %{
      transaction: transaction_to_map(transaction)
    }
  end

  def delete(%{transaction: transaction}) do
    %{
      message: "Transação deletada com sucesso",
      deleted_transaction: transaction_to_map(transaction)
    }
  end

  defp transaction_to_map(%Transaction{} = transaction) do
    %{
      id: transaction.id,
      category_id: transaction.category_id,
      category: %{
        id: transaction.category.id,
        title: transaction.category.title
      },
      title: transaction.title,
      movement: transaction.movement,
      value_in_cents: transaction.value_in_cents,
      date: transaction.date,
      due_date: transaction.due_date,
      is_fixed: transaction.is_fixed,
      is_paid: transaction.is_paid
    }
  end
end
