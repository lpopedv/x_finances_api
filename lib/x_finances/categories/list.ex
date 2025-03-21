defmodule XFinances.Categories.List do
  alias XFinances.Categories.Category
  alias XFinances.Repo

  def call, do: Repo.all(Category)
end
