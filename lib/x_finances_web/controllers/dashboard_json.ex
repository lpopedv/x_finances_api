defmodule XFinancesWeb.DashboardJSON do
  def dashboard_data(%{dashboard_data: dashboard_data}) do
    %{
      dashboard_data: dashboard_data_to_map(dashboard_data)
    }
  end

  defp dashboard_data_to_map(dashboard_data) do
    %{
      fixed_expenses: dashboard_data.fixed_expenses,
      monthly_expenses: dashboard_data.monthly_expenses,
      next_month_expenses: dashboard_data.next_month_expenses,
      charts: %{
        spents_by_category: dashboard_data.charts.spents_by_category
      }
    }
  end
end
