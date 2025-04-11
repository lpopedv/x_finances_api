defmodule XFinancesWeb.DashboardControllerTest do
  use XFinancesWeb.ConnCase, async: true

  import XFinances.Factory

  describe "get_dashboard_data/1" do
    setup %{conn: conn} do
      user = insert(:user)
      token = XFinances.GenAuthToken.call(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      today = Date.utc_today()
      {next_month_start, _} = XFinances.TestHelpers.next_month_bounds()

      {:ok, %{id: category_id_01}} =
        XFinances.Categories.create(%{user_id: user.id, title: "Fixed expenses"})

      {:ok, %{id: category_id_02}} =
        XFinances.Categories.create(%{user_id: user.id, title: "Food"})

      XFinances.Transactions.create(%{
        user_id: user.id,
        category_id: category_id_01,
        title: "gym",
        movement: "outgoing",
        value_in_cents: 15_000,
        is_fixed: true,
        is_paid: false
      })

      XFinances.Transactions.create(%{
        user_id: user.id,
        category_id: category_id_01,
        title: "rent",
        movement: "outgoing",
        value_in_cents: 60_000,
        is_fixed: true,
        is_paid: false
      })

      XFinances.Transactions.create(%{
        user_id: user.id,
        category_id: category_id_02,
        title: "burguer",
        movement: "outgoing",
        value_in_cents: 6_000,
        date: today,
        is_fixed: false,
        is_paid: false
      })

      XFinances.Transactions.create(%{
        user_id: user.id,
        category_id: category_id_02,
        title: "lunch",
        movement: "outgoing",
        value_in_cents: 5_000,
        date: today,
        is_fixed: false,
        is_paid: false
      })

      XFinances.Transactions.create(%{
        user_id: user.id,
        category_id: category_id_02,
        title: "subscription",
        movement: "outgoing",
        value_in_cents: 5_000,
        date: today,
        due_date: next_month_start,
        is_fixed: false,
        is_paid: false
      })

      {:ok, conn: conn}
    end

    test "should be able to get all dashboard data", %{conn: conn} do
      response =
        conn
        |> get(~p"/api/dashboard_data")
        |> json_response(:ok)

      assert %{
               "dashboard_data" => %{
                 "fixed_expenses" => 75_000,
                 "monthly_expenses" => 16_000,
                 "next_month_expenses" => 5000,
                 "charts" => %{
                   "spents_by_category" => [
                     %{"category" => "Fixed expenses", "spent" => 75_000},
                     %{"category" => "Food", "spent" => 16_000}
                   ]
                 }
               }
             } == response
    end
  end
end
