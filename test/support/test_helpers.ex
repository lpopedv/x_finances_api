defmodule XFinances.TestHelpers do
  def current_month_bounds do
    today = Date.utc_today()
    {Date.beginning_of_month(today), Date.end_of_month(today)}
  end

  def next_month_bounds do
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
