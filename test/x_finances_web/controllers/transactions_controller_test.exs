defmodule XFinancesWeb.TransactionsControllerTest do
  use XFinancesWeb.ConnCase, async: true

  describe "create/2" do
    setup %{conn: conn} do
      {:ok, %{id: category_id}} =
        XFinances.Categories.create(%{
          title: "Fixed Expenses",
          description: "Expenses related to fixed transactions"
        })

      %{conn: conn, category_id: category_id}
    end

    test "should be able to create a new transaction", %{conn: conn, category_id: category_id} do
      params = %{
        category_id: category_id,
        title: "gym",
        movement: "outgoing",
        value_in_cents: 15_000,
        date: Date.utc_today(),
        due_date: Date.utc_today(),
        is_fixed: true,
        is_paid: false
      }

      response =
        conn
        |> post(~p"/api/transactions", params)
        |> json_response(:created)

      assert %{
               "message" => "Transação criada com sucesso",
               "new_transaction" => %{
                 "date" => "2025-03-21",
                 "due_date" => "2025-03-21",
                 "id" => _id,
                 "is_fixed" => true,
                 "is_paid" => false,
                 "movement" => "outgoing",
                 "title" => "gym",
                 "value_in_cents" => 15_000
               }
             } = response
    end
  end

  describe "update/2" do
    setup %{conn: conn} do
      {:ok, %{id: category_id}} =
        XFinances.Categories.create(%{
          title: "Fixed Expenses",
          description: "Expenses related to fixed transactions"
        })

      {:ok, transaction} =
        XFinances.Transactions.create(%{
          category_id: category_id,
          title: "gym",
          movement: "outgoing",
          value_in_cents: 1200,
          date: Date.utc_today(),
          due_date: Date.utc_today(),
          is_fixed: true,
          is_paid: false
        })

      %{conn: conn, transaction: transaction}
    end

    test "should be able to update transaction", %{conn: conn, transaction: transaction} do
      {:ok, %{id: other_category_id}} =
        XFinances.Categories.create(%{
          title: "Other Category",
          description: "Expenses related to Other Category"
        })

      update_params = %{
        category_id: other_category_id,
        title: "gym updated",
        movement: "outgoing",
        value_in_cents: 1000,
        date: Date.utc_today(),
        due_date: Date.utc_today(),
        is_fixed: true,
        is_paid: false
      }

      response =
        conn
        |> put(~p"/api/transactions/#{transaction.id}", update_params)
        |> json_response(:ok)

      assert %{
               "message" => "Transação atualizada com sucesso",
               "updated_transaction" => %{
                 "date" => "2025-03-21",
                 "due_date" => "2025-03-21",
                 "id" => _id,
                 "is_fixed" => true,
                 "is_paid" => false,
                 "movement" => "outgoing",
                 "title" => "gym updated",
                 "value_in_cents" => 1000
               }
             } = response
    end
  end

  describe "index/2" do
    setup %{conn: conn} do
      {:ok, %{id: category_id}} =
        XFinances.Categories.create(%{
          title: "Fixed Expenses",
          description: "Expenses related to fixed transactions"
        })

      {:ok, transaction01} =
        XFinances.Transactions.create(%{
          category_id: category_id,
          title: "gym",
          movement: "outgoing",
          value_in_cents: 15_000,
          date: Date.utc_today(),
          due_date: Date.utc_today(),
          is_fixed: true,
          is_paid: false
        })

      {:ok, transaction02} =
        XFinances.Transactions.create(%{
          category_id: category_id,
          title: "other category",
          movement: "outgoing",
          value_in_cents: 19_000,
          date: Date.utc_today(),
          due_date: Date.utc_today(),
          is_fixed: true,
          is_paid: false
        })

      %{conn: conn, transactions: [transaction01, transaction02]}
    end

    test "should be able to list all transactions", %{
      conn: conn,
      transactions: [transaction01, transaction02]
    } do
      response =
        conn
        |> get(~p"/api/transactions")
        |> json_response(:ok)

      today_date = Date.utc_today()

      assert %{
               "transactions" => [
                 %{
                   "date" => date1,
                   "due_date" => due_date1,
                   "id" => id1,
                   "is_fixed" => true,
                   "is_paid" => false,
                   "movement" => "outgoing",
                   "title" => "gym",
                   "value_in_cents" => 15_000
                 },
                 %{
                   "date" => date2,
                   "due_date" => due_date2,
                   "id" => id2,
                   "is_fixed" => true,
                   "is_paid" => false,
                   "movement" => "outgoing",
                   "title" => "other category",
                   "value_in_cents" => 19_000
                 }
               ]
             } = response

      assert Date.from_iso8601!(date1) == today_date
      assert Date.from_iso8601!(due_date1) == today_date
      assert Date.from_iso8601!(date2) == today_date
      assert Date.from_iso8601!(due_date2) == today_date

      assert id1 == transaction01.id
      assert id2 == transaction02.id
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      {:ok, %{id: category_id}} =
        XFinances.Categories.create(%{
          title: "Category",
          description: "Description"
        })

      {:ok, transaction} =
        XFinances.Transactions.create(%{
          category_id: category_id,
          title: "gym",
          movement: "outgoing",
          value_in_cents: 15_000,
          date: Date.utc_today(),
          due_date: Date.utc_today(),
          is_fixed: true,
          is_paid: false
        })

      %{conn: conn, transaction: transaction}
    end

    test "should be able to get transaction by id", %{conn: conn, transaction: transaction} do
      response =
        conn
        |> get(~p"/api/transactions/#{transaction.id}")
        |> json_response(:ok)

      assert %{
               "transaction" => %{
                 "date" => date,
                 "due_date" => due_date,
                 "id" => transaction_id,
                 "is_fixed" => true,
                 "is_paid" => false,
                 "movement" => "outgoing",
                 "title" => "gym",
                 "value_in_cents" => 15_000
               }
             } =
               response

      assert transaction_id == transaction.id

      today_date = Date.utc_today()

      assert Date.from_iso8601!(date) == today_date
      assert Date.from_iso8601!(due_date) == today_date
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      {:ok, %{id: category_id}} =
        XFinances.Categories.create(%{
          title: "Category",
          description: "Description"
        })

      {:ok, %{id: transaction_id}} =
        XFinances.Transactions.create(%{
          category_id: category_id,
          title: "gym",
          movement: "outgoing",
          value_in_cents: 15_000,
          date: Date.utc_today(),
          due_date: Date.utc_today(),
          is_fixed: true,
          is_paid: false
        })

      %{conn: conn, transaction_id: transaction_id}
    end

    test "should be able to delete transaction", %{conn: conn, transaction_id: transaction_id} do
      response =
        conn
        |> delete(~p"/api/transactions/#{transaction_id}")
        |> json_response(:ok)

      assert %{
               "message" => "Transação deletada com sucesso",
               "deleted_transaction" => %{
                 "date" => date,
                 "due_date" => due_date,
                 "id" => response_transaction_id,
                 "is_fixed" => true,
                 "is_paid" => false,
                 "movement" => "outgoing",
                 "title" => "gym",
                 "value_in_cents" => 15_000
               }
             } =
               response

      assert response_transaction_id == transaction_id

      today_date = Date.utc_today()

      assert Date.from_iso8601!(date) == today_date
      assert Date.from_iso8601!(due_date) == today_date
    end
  end
end
