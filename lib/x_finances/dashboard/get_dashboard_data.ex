defmodule XFinances.Dashboard.GetDashboardData do
  import Ecto.Query

  alias XFinances.Repo
  alias XFinances.Transactions.Transaction

  def call do
    %{
      fixed_expenses: get_data(:fixed_expenses),
      monthly_expenses: get_data(:monthly_expenses),
      next_month_expeses: get_data(:next_month_expenses)
    }
  end

  defp get_data(:fixed_expenses) do
    Transaction
    |> where([t], t.is_fixed == true)
    |> where([t], t.movement == :outgoing)
    |> select([t], sum(t.value_in_cents))
    |> Repo.one() || 0
  end

  defp get_data(:monthly_expenses) do
    {start_date, end_date} = current_month_bounds()

    Transaction
    |> where([t], t.movement == :outgoing)
    |> where([t], not t.is_fixed)
    |> where([t], t.date >= ^start_date and t.date <= ^end_date)
    |> select([t], sum(t.value_in_cents))
    |> Repo.one() || 0
  end

  defp get_data(:next_month_expenses) do
    {next_month_start, next_month_end} = next_month_bounds()

    Transaction
    |> where([t], t.movement == :outgoing)
    |> where([t], not t.is_fixed)
    |> where([t], t.due_date >= ^next_month_start and t.due_date <= ^next_month_end)
    |> select([t], sum(t.value_in_cents))
    |> Repo.one() || 0
  end

  defp current_month_bounds do
    today = Date.utc_today()
    {Date.beginning_of_month(today), Date.end_of_month(today)}
  end

  defp next_month_bounds do
    today = Date.utc_today()
    {year, month} = {today.year, today.month}

    {next_year, next_month} =
      if month == 12 do
        {year + 1, 1}
      else
        {year, month + 1}
      end

    next_month_start = Date.new!(next_year, next_month, 1)
    next_month_end = Date.end_of_month(next_month_start)
    {next_month_start, next_month_end}
  end
end
