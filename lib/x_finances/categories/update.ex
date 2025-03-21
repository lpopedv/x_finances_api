defmodule XFinances.Categories.Update do
  alias XFinances.Categories.Category
  alias XFinances.Repo

  def call(%{"id" => id} = params) do
    case Repo.get(Category, id) do
      nil -> {:error, :not_found}
      category -> update(category, params)
    end
  end

  defp update(category, params) do
    category
    |> Category.changeset(params)
    |> Repo.update()
  end
end
