defmodule XFinancesWeb.DashboardController do
  use XFinancesWeb, :controller

  def get_dashboard_data(conn, _params) do
    data = XFinances.Dashboard.GetDashboardData.call()

    conn
    |> put_status(:ok)
    |> render(:dashboard_data, dashboard_data: data)
  end
end
