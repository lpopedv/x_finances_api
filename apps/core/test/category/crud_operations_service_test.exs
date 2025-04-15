defmodule Core.Category.Services.CrudOperationsServiceTest do
  alias Core.Schemas.Category
  alias Core.Category.Services.CrudOperationsService
  use Core.DataCase, async: true

  import Core.Factory

  describe "create/1" do
    test "should be able to create a new category" do
      user = insert(:user)

      params = %{
        title: "Category 01",
        description: "Category 01 Description",
        user_id: user.id
      }

      assert {:ok, %Category{} = category} = CrudOperationsService.create(params)

      assert category.title == params.title
      assert category.description == params.description
      assert category.user_id == user.id
    end
  end

  describe "update/2" do
    setup do
      user = insert(:user)
      category = insert(:category)
      %{user: user, category: category}
    end

    test "should be able to update a category", %{category: category} do
      assert %{
               title: "Category",
               description: "Category for transactions"
             } = category

      params_to_update = %{
        title: "Updated Category Title",
        description: "Updated description"
      }

      {:ok, updated_category} = CrudOperationsService.update(category.id, params_to_update)

      assert updated_category.title == params_to_update.title
      assert updated_category.description == params_to_update.description
    end

    test "should not be able to update category if it does not exist" do
      assert {:error, :not_found} = CrudOperationsService.update(Ecto.UUID.generate(), %{})
    end
  end

  describe "delete/1" do
    test "should be able to delete category" do
      category = insert(:category)

      {:ok, deleted_category} = CrudOperationsService.delete(category.id)

      assert Repo.get(Category, deleted_category.id) == nil
    end

    test "should not be able to delete category if it does not exist" do
      assert {:error, :not_found} = CrudOperationsService.delete(Ecto.UUID.generate())
    end
  end

  describe "show/1" do
    test "should be able to get a category with user association" do
      category = insert(:category)

      {:ok, found_category} = CrudOperationsService.show(category.id)

      assert %{
               title: "Category",
               description: "Category for transactions",
               user_id: _user_id
             } = found_category
    end

    test "should not be able to show category if it does not exist" do
      assert {:error, :not_found} = CrudOperationsService.show(Ecto.UUID.generate())
    end
  end

  describe "list/0" do
    test "should be able to list all categories" do
      insert_list(3, :category)

      categories = CrudOperationsService.list()
      assert length(categories) == 3
      assert Enum.all?(categories, &(&1.__struct__ == Category))
    end

    test "should return empty list when no categories exist" do
      assert [] = CrudOperationsService.list()
    end
  end
end
