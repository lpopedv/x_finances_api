defmodule XFinances.Factory do
  use ExMachina.Ecto, repo: XFinances.Repo

  def user_factory do
    password = "ValidPassword123!"

    %XFinances.Users.User{
      full_name: "User Name",
      email: sequence(:email, &"user#{&1}@email.com"),
      password: password,
      password_hash: Argon2.hash_pwd_salt(password),
      is_active: true,
      base_income: 0
    }
  end

  def category_factory do
    %XFinances.Schemas.Category{
      user: build(:user),
      title: sequence(:title, &"Category #{&1}"),
      description: "Category for transactions"
    }
  end

  def transaction_factory do
    %XFinances.Transactions.Transaction{
      user: build(:user),
      category: insert(:category),
      title: "Transaction 01",
      movement: :outgoing,
      value_in_cents: 340_000,
      date: Date.utc_today(),
      due_date: nil,
      is_fixed: true,
      is_paid: false
    }
  end
end
