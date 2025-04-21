defmodule Finances.Categories.Services.CrudOperationsService do
  alias Finances.Schemas.Category
  alias Finances.Repo
  import Ecto.Query

  def create(user_id, new_category_params) do
    new_category_params
    |> Map.put(:user_id, user_id)
    |> Category.changeset()
    |> Repo.insert()
  end

  def update(user_id, category_id, new_category_params) do
    case Repo.get_by(Category, id: category_id, user_id: user_id) do
      nil ->
        {:error, :not_found}

      category ->
        category
        |> Category.changeset(new_category_params)
        |> Repo.update()
    end
  end

  def delete(user_id, category_id) do
    case Repo.get_by(Category, id: category_id, user_id: user_id) do
      nil -> {:error, :not_found}
      category -> Repo.delete(category)
    end
  end

  def list(user_id) do
    Category
    |> where([c], c.user_id == ^user_id)
    |> Repo.all()
  end

  def show(user_id, category_id) do
    case Repo.get_by(Category, id: category_id, user_id: user_id) do
      nil -> {:error, :not_found}
      category -> {:ok, category}
    end
  end
end
