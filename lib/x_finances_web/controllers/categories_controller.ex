defmodule XFinancesWeb.CategoriesController do
  use XFinancesWeb, :controller

  alias XFinances.Categories
  alias XFinances.Schemas.Category
  alias XFinancesWeb.FallbackController

  action_fallback FallbackController

  def index(conn, _params) do
    categories = Categories.list()

    conn
    |> put_status(:ok)
    |> render(:index, categories: categories)
  end

  def create(conn, params) do
    with {:ok, %Category{} = category} <- Categories.create(params) do
      conn
      |> put_status(:created)
      |> render(:create, category: category)
    end
  end

  def update(conn, params) do
    with {:ok, %Category{} = category} <- Categories.update(params["id"], params) do
      conn
      |> put_status(:ok)
      |> render(:update, category: category)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Category{} = category} <- Categories.show(id) do
      conn
      |> put_status(:ok)
      |> render(:show, %{category: category})
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Category{} = category} <- Categories.delete(id) do
      conn
      |> put_status(:ok)
      |> render(:delete, %{category: category})
    end
  end
end
