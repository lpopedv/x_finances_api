defmodule XFinances.Categories do
  alias XFinances.Categories.CrudOperations

  defdelegate create(params), to: CrudOperations
  defdelegate update(category, params), to: CrudOperations
  defdelegate delete(id), to: CrudOperations
  defdelegate list(), to: CrudOperations
  defdelegate show(id), to: CrudOperations
end
