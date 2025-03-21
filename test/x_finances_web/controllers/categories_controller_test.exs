defmodule XFinancesWeb.CategoriesControllerTest do
  use XFinancesWeb.ConnCase, async: true

  describe "create/2" do
    test "should be able to create a new category", %{conn: conn} do
      params = %{
        title: "Test category 01",
        description: "Teste category 01 description"
      }

      response =
        conn
        |> post(~p"/api/categories", params)
        |> json_response(:created)

      assert %{
               "message" => "Categoria criada com sucesso",
               "new_category" => %{
                 "description" => "Teste category 01 description",
                 "id" => _id,
                 "title" => "Test category 01"
               }
             } = response
    end
  end

  describe "update/2" do
    setup %{conn: conn} do
      {:ok, category} =
        XFinances.Categories.create(%{
          title: "Initial Category",
          description: "Initial description"
        })

      %{conn: conn, category: category}
    end

    test "should be able to update category", %{conn: conn, category: category} do
      update_params = %{
        title: "Updated Category",
        description: "Updated Description"
      }

      response =
        conn
        |> put(~p"/api/categories/#{category.id}", update_params)
        |> json_response(:ok)

      category_id = category.id

      assert %{
               "message" => "Categoria atualizada com sucesso",
               "updated_category" => %{
                 "description" => "Updated Description",
                 "id" => ^category_id,
                 "title" => "Updated Category"
               }
             } = response
    end
  end

  describe "index/2" do
    setup %{conn: conn} do
      {:ok, category01} =
        XFinances.Categories.create(%{
          title: "Category 01",
          description: "Category 01 Description"
        })

      {:ok, category02} =
        XFinances.Categories.create(%{
          title: "Category 02",
          description: "Category 02 Description"
        })

      %{conn: conn, categories: [category01, category02]}
    end

    test "should be able to list all categories", %{
      conn: conn,
      categories: [category01, category02]
    } do
      response =
        conn
        |> get(~p"/api/categories")
        |> json_response(:ok)

      assert %{
               "categories" => [
                 %{
                   "description" => "Category 01 Description",
                   "id" => id1,
                   "title" => "Category 01"
                 },
                 %{
                   "description" => "Category 02 Description",
                   "id" => id2,
                   "title" => "Category 02"
                 }
               ]
             } = response

      assert id1 == category01.id
      assert id2 == category02.id
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      {:ok, category} =
        XFinances.Categories.create(%{
          title: "Category",
          description: "Description"
        })

      %{conn: conn, category: category}
    end

    test "should be able to get category by id", %{conn: conn, category: category} do
      response =
        conn
        |> get(~p"/api/categories/#{category.id}")
        |> json_response(:ok)

      assert %{
               "category" => %{
                 "description" => "Description",
                 "id" => category_id,
                 "title" => "Category"
               }
             } =
               response

      assert category_id == category.id
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      {:ok, category} =
        XFinances.Categories.create(%{
          title: "Category",
          description: "Description"
        })

      %{conn: conn, category: category}
    end

    test "should be able to delete category", %{conn: conn, category: category} do
      response =
        conn
        |> delete(~p"/api/categories/#{category.id}")
        |> json_response(:ok)

      assert %{
               "deleted_category" => %{
                 "description" => "Description",
                 "id" => category_id,
                 "title" => "Category"
               },
               "message" => "Categoria deletada com sucesso"
             } =
               response

      assert category_id == category.id
    end
  end
end
