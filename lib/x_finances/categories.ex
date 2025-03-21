defmodule XFinances.Categories do
  alias XFinances.Categories.Create
  alias XFinances.Categories.Update
  alias XFinances.Categories.Delete
  alias XFinances.Categories.List
  alias XFinances.Categories.Show

  defdelegate create(params), to: Create, as: :call
  defdelegate update(params), to: Update, as: :call
  defdelegate delete(id), to: Delete, as: :call
  defdelegate list(), to: List, as: :call
  defdelegate show(id), to: Show, as: :call
end
