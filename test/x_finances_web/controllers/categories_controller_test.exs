defmodule XFinancesWeb.CategoriesControllerTest do
  use XFinancesWeb.ConnCase, async: true

  import XFinances.Factory

  setup %{conn: conn} do
    user = insert(:user)
    token = XFinances.GenAuthToken.call(user)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    {:ok, conn: conn, user: user, user_id: user.id}
  end

  describe "create/2" do
    test "should be able to create a new category", %{conn: conn, user_id: user_id} do
      params = %{
        user_id: user_id,
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
    setup %{user_id: user_id} do
      {:ok, category} =
        XFinances.Categories.create(%{
          user_id: user_id,
          title: "Initial Category",
          description: "Initial description"
        })

      {:ok, category: category}
    end

    test "should be able to update category", %{conn: conn, category: category} do
      update_params = %{
        user_id: category.user_id,
        title: "Updated Category",
        description: "Updated Description"
      }

      response =
        conn
        |> put(~p"/api/categories/#{category.id}", update_params)
        |> json_response(:ok)

      assert %{
               "message" => "Categoria atualizada com sucesso",
               "updated_category" => %{
                 "description" => "Updated Description",
                 "title" => "Updated Category"
               }
             } = response
    end
  end

  describe "index/2" do
    setup %{user_id: user_id} do
      {:ok, cat1} =
        XFinances.Categories.create(%{
          user_id: user_id,
          title: "Category 01",
          description: "Category 01 Description"
        })

      {:ok, cat2} =
        XFinances.Categories.create(%{
          user_id: user_id,
          title: "Category 02",
          description: "Category 02 Description"
        })

      {:ok, categories: [cat1, cat2]}
    end

    test "should be able to list all categories", %{conn: conn, categories: [cat1, cat2]} do
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

      assert id1 == cat1.id
      assert id2 == cat2.id
    end
  end

  describe "show/2" do
    setup %{user_id: user_id} do
      {:ok, category} =
        XFinances.Categories.create(%{
          user_id: user_id,
          title: "Category",
          description: "Description"
        })

      {:ok, category: category}
    end

    test "should be able to get category by id", %{conn: conn, category: category} do
      response =
        conn
        |> get(~p"/api/categories/#{category.id}")
        |> json_response(:ok)

      assert %{
               "category" => %{
                 "description" => "Description",
                 "id" => id,
                 "title" => "Category"
               }
             } = response

      assert id == category.id
    end
  end

  describe "delete/2" do
    setup %{user_id: user_id} do
      {:ok, category} =
        XFinances.Categories.create(%{
          user_id: user_id,
          title: "Category",
          description: "Description"
        })

      {:ok, category: category}
    end

    test "should be able to delete category", %{conn: conn, category: category} do
      response =
        conn
        |> delete(~p"/api/categories/#{category.id}")
        |> json_response(:ok)

      assert %{
               "deleted_category" => %{
                 "description" => "Description",
                 "title" => "Category"
               },
               "message" => "Categoria deletada com sucesso"
             } = response
    end
  end
end
