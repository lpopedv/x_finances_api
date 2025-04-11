defmodule XFinances.Dashboard.GetDashboardData do
  import Ecto.Query

  alias XFinances.Schemas.Category
  alias XFinances.Repo
  alias XFinances.Schemas.Transaction

  def call(user_id) do
    %{
      fixed_expenses: get_data(:fixed_expenses, user_id),
      monthly_expenses: get_data(:monthly_expenses, user_id),
      next_month_expenses: get_data(:next_month_expenses, user_id),
      charts: %{
        spents_by_category: get_chart(:spents_by_category, user_id)
      }
    }
  end

  defp get_data(:fixed_expenses, user_id) do
    Transaction
    |> where([t], t.user_id == ^user_id)
    |> where([t], t.is_fixed == true)
    |> where([t], t.movement == :outgoing)
    |> select([t], sum(t.value_in_cents))
    |> Repo.one() || 0
  end

  defp get_data(:monthly_expenses, user_id) do
    {start_date, end_date} = current_month_bounds()

    Transaction
    |> where([t], t.user_id == ^user_id)
    |> where([t], t.movement == :outgoing)
    |> where([t], not t.is_fixed)
    |> where([t], t.date >= ^start_date and t.date <= ^end_date)
    |> select([t], sum(t.value_in_cents))
    |> Repo.one() || 0
  end

  defp get_data(:next_month_expenses, user_id) do
    {next_month_start, next_month_end} = next_month_bounds()

    Transaction
    |> where([t], t.user_id == ^user_id)
    |> where([t], t.movement == :outgoing)
    |> where([t], not t.is_fixed)
    |> where(
      [t],
      t.due_date >= ^next_month_start and t.due_date <= ^next_month_end and t.is_paid == false
    )
    |> select([t], sum(t.value_in_cents))
    |> Repo.one() || 0
  end

  defp get_chart(:spents_by_category, user_id) do
    {start_date, end_date} = current_month_bounds()

    transactions_query =
      from t in Transaction,
        where:
          t.user_id == ^user_id and
            t.movement == :outgoing and
            ((t.date >= ^start_date and t.date <= ^end_date) or t.is_fixed == true),
        group_by: t.category_id,
        order_by: [desc: sum(t.value_in_cents)],
        select: %{category_id: t.category_id, spent: sum(t.value_in_cents)}

    transactions = Repo.all(transactions_query)
    category_ids = Enum.map(transactions, & &1.category_id)

    categories_query =
      from c in Category,
        where: c.id in ^category_ids,
        select: %{id: c.id, title: c.title}

    categories = Repo.all(categories_query)

    Enum.map(transactions, fn %{category_id: category_id, spent: spent} ->
      found_category = Enum.find(categories, fn c -> c.id == category_id end)

      title =
        case found_category do
          nil -> "Desconhecido"
          cat -> cat.title
        end

      %{category: title, spent: spent}
    end)
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
