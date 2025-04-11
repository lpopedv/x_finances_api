defmodule XFinancesWeb.DashboardController do
  use XFinancesWeb, :controller

  def get_dashboard_data(conn, _params) do
    user_id = conn.assigns.current_user.id
    dashboard_data = XFinances.Dashboard.GetDashboardData.call(user_id)
    render(conn, :dashboard_data, dashboard_data: dashboard_data)
  end
end
