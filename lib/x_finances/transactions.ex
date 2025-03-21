defmodule XFinances.Transactions do
  alias XFinances.Transactions.Create
  alias XFinances.Transactions.Update
  alias XFinances.Transactions.Delete
  alias XFinances.Transactions.List
  alias XFinances.Transactions.Show

  defdelegate create(params), to: Create, as: :call
  defdelegate update(params), to: Update, as: :call
  defdelegate delete(id), to: Delete, as: :call
  defdelegate list(), to: List, as: :call
  defdelegate show(id), to: Show, as: :call
end
