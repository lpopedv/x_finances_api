defmodule XFinances.Transactions do
  alias XFinances.Transactions.CrudOperations

  defdelegate create(params), to: CrudOperations
  defdelegate update(transaction, params), to: CrudOperations
  defdelegate delete(id), to: CrudOperations
  defdelegate list(), to: CrudOperations
  defdelegate show(id), to: CrudOperations
end
