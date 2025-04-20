defmodule Core.User.Services.CrudOperationsServiceTest do
  alias Core.Schemas.User
  alias Core.User.Services.CrudOperationsService
  use Core.DataCase, async: true

  import Core.Factory

  describe "create/1" do
    test "should be able to create a new user" do
      params = %{
        full_name: "Jon Doe",
        email: "jon@example.com",
        base_income: 150_000,
        password: "123456"
      }

      {:ok, new_user} = CrudOperationsService.create(params)

      assert new_user.full_name == params.full_name
      assert new_user.email == params.email
      assert new_user.base_income == params.base_income
    end
  end

  describe "update/2" do
    test "should be able to update a user" do
      user = insert(:user)

      assert %{
               full_name: "User Name",
               password: "password123",
               base_income: 0
             } = user

      params_to_update = %{
        full_name: "updated user full name",
        email: "jon@updated.com",
        password: "newPassword",
        base_income: 250_000
      }

      {:ok, updated_user} = CrudOperationsService.update(user.id, params_to_update)

      assert updated_user.full_name == params_to_update.full_name
      assert updated_user.email == params_to_update.email
      assert updated_user.base_income == params_to_update.base_income
    end

    test "should not be able to update user if they do not exist" do
      assert {:error, :not_found} = CrudOperationsService.update(Ecto.UUID.generate(), %{})
    end
  end

  describe "delete/1" do
    test "should be able to delete user" do
      user = insert(:user)

      {:ok, _} = CrudOperationsService.delete(user.id)

      assert Repo.get(User, user.id) == nil
    end

    test "should not be able to delete user if they do not exist" do
      assert {:error, :not_found} = CrudOperationsService.delete(Ecto.UUID.generate())
    end
  end

  describe "get_by_id/1" do
    test "should be able to get a user" do
      new_user = insert(:user)

      {:ok, user} = CrudOperationsService.get_by_id(new_user.id)

      assert %{
               full_name: "User Name",
               password: nil,
               password_hash: _,
               base_income: 0
             } = user
    end

    test "should not be able to get user if they do not exist" do
      assert {:error, :not_found} = CrudOperationsService.get_by_id(Ecto.UUID.generate())
    end
  end

  describe "get_by_email/1" do
    test "should be able to get a user by email" do
      new_user = insert(:user)

      {:ok, user} = CrudOperationsService.get_by_email(new_user.email)

      assert %{
               full_name: "User Name",
               password: nil,
               password_hash: _,
               base_income: 0
             } = user
    end

    test "should not be able to get user if they do not exist" do
      assert {:error, :not_found} = CrudOperationsService.get_by_id(Ecto.UUID.generate())
    end
  end
end
