defmodule XFinances.Schemas.TransactionTest do
  alias XFinances.Schemas.Transaction

  use XFinances.DataCase, async: true

  import XFinances.Factory

  describe "changeset/2" do
    setup do
      user = insert(:user)
      category = insert(:category)

      required_params = %{
        category_id: category.id,
        user_id: user.id,
        title: "Test Transaction",
        movement: :outgoing,
        value_in_cents: 150_000
      }

      %{required_params: required_params, category: category}
    end

    test "returns valid changeset with valid attributes", %{required_params: params} do
      changeset = Transaction.changeset(params)
      assert changeset.valid?
    end

    for field <- [:category_id, :user_id, :title, :movement, :value_in_cents] do
      test "returns invalid changeset when #{field} is missing", %{required_params: params} do
        invalid_params = Map.delete(params, unquote(field))

        changeset = Transaction.changeset(invalid_params)

        refute changeset.valid?
        assert "can't be blank" in errors_on(changeset)[unquote(field)]
      end
    end

    test "returns invalid changeset (title length)", %{required_params: params} do
      invalid_title_min_length_params = %{params | title: "ab"}

      changeset = Transaction.changeset(invalid_title_min_length_params)

      refute changeset.valid?

      assert "should be at least 3 character(s)" in errors_on(changeset)[unquote(:title)]

      invalid_title_max_length_params = %{params | title: String.duplicate("a", 101)}

      changeset = Transaction.changeset(invalid_title_max_length_params)

      assert "should be at most 100 character(s)" in errors_on(changeset)[unquote(:title)]
    end

    test "returns invalid changeset (value_in_cents greater than 0)", %{required_params: params} do
      invalid_value_in_cents_greater_than_params = %{params | value_in_cents: -500}

      changeset = Transaction.changeset(invalid_value_in_cents_greater_than_params)

      assert "must be greater than 0" in errors_on(changeset)[unquote(:value_in_cents)]

      refute changeset.valid?
    end

    test "returns error when due_date is in the past", %{required_params: params} do
      past_date = Date.add(Date.utc_today(), -1)
      invalid_past_date_params = Map.put(params, :due_date, past_date)

      changeset = Transaction.changeset(invalid_past_date_params)

      refute changeset.valid?
      assert "cannot be in the past" in errors_on(changeset)[:due_date]
    end

    test "returns error when date is after due_date", %{required_params: params} do
      today = Date.utc_today()

      invalid_after_due_date_params =
        params
        |> Map.put(:due_date, today)
        |> Map.put(:date, Date.add(today, 1))

      changeset = Transaction.changeset(invalid_after_due_date_params)

      refute changeset.valid?
      assert "cannot be after due date" in errors_on(changeset)[:date]
    end

    test "accepts date before or equal to due_date", %{required_params: params} do
      today = Date.utc_today()

      valid_date_before_equal_due_date_params =
        params
        |> Map.put(:due_date, today)
        |> Map.put(:date, today)

      changeset = Transaction.changeset(valid_date_before_equal_due_date_params)

      assert changeset.valid?
    end

    test "persists with valid params", %{required_params: params} do
      assert %Transaction{} =
               params
               |> Transaction.changeset()
               |> Repo.insert!()
    end
  end
end
