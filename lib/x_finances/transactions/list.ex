defmodule XFinances.Transactions.List do
  alias XFinances.Transactions.Transaction
  alias XFinances.Repo

  def call do
    Repo.preload(Repo.all(Transaction), :category)
  end
end
