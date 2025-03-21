defmodule XFinances.Categories.Delete do
  alias XFinances.Categories.Category
  alias XFinances.Repo

  def call(id) do
    case Repo.get(Category, id) do
      nil -> {:error, :not_found}
      category -> Repo.delete(category)
    end
  end
end
