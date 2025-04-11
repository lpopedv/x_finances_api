defmodule XFinances.Seeds do
  alias XFinances.Schemas.Transaction
  alias XFinances.Schemas.User
  alias XFinances.Repo
  alias XFinances.Schemas.Category

  def run do
    create_users()
    categories = create_categories()
    create_transactions(categories)
  end

  defp create_users do
    %{
      "full_name" => "Jon Doe",
      "email" => "jon@doe.com",
      "password" => "A123456789101112",
      "is_active" => true,
      "base_income" => 1000
    }
    |> User.changeset()
    |> Repo.insert!()
  end

  defp create_categories do
    jon_user = Repo.get_by!(User, email: "jon@doe.com")

    categories = [
      %Category{
        user_id: jon_user.id,
        title: "Credit Card X",
        description: "X Credit Card Transactions"
      },
      %Category{
        user_id: jon_user.id,
        title: "Snacks & Fast Food",
        description: "Expenses on burgers, pizza and other quick bites"
      }
    ]

    Enum.map(categories, &Repo.insert!/1)
  end

  defp create_transactions(categories) do
    jon_user = Repo.get_by!(User, email: "jon@doe.com")

    credit_card_x_category =
      Enum.find(categories, fn category -> category.title == "Credit Card X" end)

    snacks_fast_food_category =
      Enum.find(categories, fn category -> category.title == "Snacks & Fast Food" end)

    transactions = [
      %Transaction{
        category_id: snacks_fast_food_category.id,
        user_id: jon_user.id,
        title: "Best Burguer Ever",
        movement: :outgoing,
        value_in_cents: 6500,
        date: Date.utc_today(),
        is_fixed: false,
        is_paid: true
      },
      %Transaction{
        category_id: credit_card_x_category.id,
        user_id: jon_user.id,
        title: "Ryzen 9 7950X",
        movement: :outgoing,
        value_in_cents: 400_000,
        date: Date.utc_today(),
        is_fixed: false,
        is_paid: false
      }
    ]

    Enum.each(transactions, &Repo.insert/1)
  end
end
