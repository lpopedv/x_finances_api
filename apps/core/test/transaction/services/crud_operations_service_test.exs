defmodule Core.Transaction.Services.CrudOperationsServiceTest do
  alias Core.Schemas.Transaction
  alias Core.Transaction.Services.CrudOperationsService
  use Core.DataCase, async: true

  import Core.Factory

  describe "create/1" do
    test "should be able to create a new transaction" do
      user = insert(:user)
      category = insert(:category)

      params = %{
        title: "New Transaction",
        movement: :outgoing,
        value_in_cents: 10000,
        user_id: user.id,
        category_id: category.id
      }

      assert {:ok, %Transaction{} = transaction} = CrudOperationsService.create(params)

      assert transaction.title == "New Transaction"
      assert transaction.movement == :outgoing
      assert transaction.value_in_cents == 10000
    end
  end

  describe "update/2" do
    test "should be able to update a transaction" do
      transaction = insert(:transaction)

      params = %{
        title: "Updated Title",
        value_in_cents: 20000
      }

      assert {:ok, updated} = CrudOperationsService.update(transaction.id, params)
      assert updated.title == "Updated Title"
      assert updated.value_in_cents == 20000
    end

    test "should not be able to update non-existent transaction" do
      assert {:error, :not_found} = CrudOperationsService.update(Ecto.UUID.generate(), %{})
    end
  end

  describe "delete/1" do
    test "should be able to delete a transaction" do
      transaction = insert(:transaction)
      assert {:ok, _} = CrudOperationsService.delete(transaction.id)
      assert Repo.get(Transaction, transaction.id) == nil
    end

    test "should not be able to delete non-existent transaction" do
      assert {:error, :not_found} = CrudOperationsService.delete(Ecto.UUID.generate())
    end
  end

  describe "list/0" do
    test "should list all transactions with preloaded associations" do
      insert_list(3, :transaction)
      transactions = CrudOperationsService.list()
      assert length(transactions) == 3
      assert Enum.all?(transactions, &Ecto.assoc_loaded?(&1.category))
      assert Enum.all?(transactions, &Ecto.assoc_loaded?(&1.user))
    end
  end

  describe "show/1" do
    test "should get transaction with preloaded associations" do
      transaction = insert(:transaction)
      assert {:ok, loaded} = CrudOperationsService.show(transaction.id)
      assert Ecto.assoc_loaded?(loaded.category)
      assert Ecto.assoc_loaded?(loaded.user)
    end

    test "should not find non-existent transaction" do
      assert {:error, :not_found} = CrudOperationsService.show(Ecto.UUID.generate())
    end
  end
end
