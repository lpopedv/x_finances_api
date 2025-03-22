defmodule XFinancesWeb.DashboardControllerTest do
  use XFinancesWeb.ConnCase, async: true

  describe "get_dashboard_data/1" do
    setup %{conn: conn} do
      {:ok, %{id: category_id_01}} = XFinances.Categories.create(%{title: "Fixed expenses"})
      {:ok, %{id: category_id_02}} = XFinances.Categories.create(%{title: "Food"})

      XFinances.Transactions.create(%{
        category_id: category_id_01,
        title: "gym",
        movement: "outgoing",
        value_in_cents: 15_000,
        is_fixed: true,
        is_paid: false
      })

      XFinances.Transactions.create(%{
        category_id: category_id_01,
        title: "rent",
        movement: "outgoing",
        value_in_cents: 60_000,
        is_fixed: true,
        is_paid: false
      })

      XFinances.Transactions.create(%{
        category_id: category_id_02,
        title: "burguer",
        movement: "outgoing",
        value_in_cents: 6000,
        date: Date.utc_today(),
        is_fixed: false,
        is_paid: false
      })

      {next_month_start, _next_month_end} = XFinances.TestHelpers.next_month_bounds()

      XFinances.Transactions.create(%{
        category_id: category_id_02,
        title: "subscription",
        movement: "outgoing",
        value_in_cents: 5000,
        date: Date.utc_today(),
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
                 "monthly_expenses" => 11_000,
                 "next_month_expeses" => 5000,
                 "charts" => %{
                   "spents_by_category" => [
                     %{"category" => "Fixed expenses", "spent" => 75_000},
                     %{"category" => "Food", "spent" => 11_000}
                   ]
                 }
               }
             } == response
    end
  end
end
