defmodule Finances.Category.Services.CrudOperationsServiceTest do
  alias Finances.Schemas.Category
  alias Finances.Categories.Services.CrudOperationsService
  use Finances.DataCase, async: true

  import Finances.Factory

  setup do
    user = insert(:user)
    %{user: user}
  end

  describe "create/1" do
    test "should be able to create a new category", %{user: user} do
      params = %{
        title: "Category 01",
        description: "Category 01 Description"
      }

      assert {:ok, %Category{} = category} = CrudOperationsService.create(user.id, params)

      assert category.title == params.title
      assert category.description == params.description
      assert category.user_id == user.id
    end
  end

  describe "update/2" do
    setup %{user: user} do
      category = insert(:category, user: user)
      %{user: user, category: category}
    end

    test "should be able to update a category", %{category: category, user: user} do
      assert %{
               title: "Category",
               description: "Category for transactions"
             } = category

      params_to_update = %{
        title: "Updated Category Title",
        description: "Updated description"
      }

      {:ok, updated_category} =
        CrudOperationsService.update(user.id, category.id, params_to_update)

      assert updated_category.title == params_to_update.title
      assert updated_category.description == params_to_update.description
    end

    test "should not be able to update category if it does not exist", %{user: user} do
      assert {:error, :not_found} =
               CrudOperationsService.update(user.id, Ecto.UUID.generate(), %{})
    end
  end

  describe "delete/1" do
    test "should be able to delete category", %{user: user} do
      category = insert(:category, user: user)

      {:ok, _} = CrudOperationsService.delete(user.id, category.id)

      assert Repo.get_by(Category, id: category.id, user_id: user.id) == nil
    end

    test "should not be able to delete category if it does not exist" do
      user = insert(:user)
      assert {:error, :not_found} = CrudOperationsService.delete(user.id, Ecto.UUID.generate())
    end
  end

  describe "show/1" do
    test "should be able to get a category with user association", %{user: user} do
      category = insert(:category, user: user)

      {:ok, found_category} = CrudOperationsService.show(user.id, category.id)

      assert %{
               title: "Category",
               description: "Category for transactions",
               user_id: _user_id
             } = found_category
    end

    test "should not be able to show category if it does not exist", %{user: user} do
      assert {:error, :not_found} = CrudOperationsService.show(user.id, Ecto.UUID.generate())
    end
  end

  describe "list/1" do
    test "should be able to list user's categories", %{user: user} do
      insert_list(3, :category, user: user)
      insert(:category)

      categories = CrudOperationsService.list(user.id)
      assert length(categories) == 3
      assert Enum.all?(categories, &(&1.__struct__ == Category))
    end

    test "should return empty list when no categories exist for user" do
      user = insert(:user)
      insert_list(2, :category)
      assert [] = CrudOperationsService.list(user.id)
    end
  end
end
