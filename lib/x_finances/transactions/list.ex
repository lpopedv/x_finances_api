defmodule XFinances.Transactions.List do
  alias XFinances.Transactions.Transaction
  alias XFinances.Repo

  def call, do: Repo.all(Transaction)
end
