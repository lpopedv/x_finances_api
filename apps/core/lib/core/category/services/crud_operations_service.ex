defmodule Core.Category.Services.CrudOperationsService do
  alias Core.Schemas.Category
  alias Core.Repo

  def create(new_category_params) do
    new_category_params
    |> Category.changeset()
    |> Repo.insert()
  end

  def update(category_id, new_category_params) do
    case Repo.get(Category, category_id) do
      nil ->
        {:error, :not_found}

      category ->
        category
        |> Category.changeset(new_category_params)
        |> Repo.update()
    end
  end

  def delete(category_id) do
    case Repo.get(Category, category_id) do
      nil -> {:error, :not_found}
      category -> Repo.delete(category)
    end
  end

  def list, do: Repo.all(Category)

  def show(category_id) do
    case Repo.get(Category, category_id) do
      nil -> {:error, :not_found}
      category -> {:ok, category}
    end
  end
end
