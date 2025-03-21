defmodule XFinancesWeb.CategoriesJSON do
  alias XFinances.Categories.Category

  def index(%{categories: categories}) do
    %{
      categories: Enum.map(categories, &category_to_map/1)
    }
  end

  def create(%{category: category}) do
    %{
      message: "Categoria criada com sucesso",
      new_category: category_to_map(category)
    }
  end

  def update(%{category: category}) do
    %{
      message: "Categoria atualizada com sucesso",
      updated_category: category_to_map(category)
    }
  end

  def show(%{category: category}) do
    %{
      category: category_to_map(category)
    }
  end

  def delete(%{category: category}) do
    %{
      message: "Categoria deletada com sucesso",
      deleted_category: category_to_map(category)
    }
  end

  defp category_to_map(%Category{} = category) do
    %{
      id: category.id,
      title: category.title,
      description: category.description
    }
  end
end
