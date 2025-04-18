defmodule Core.Factory do
  use ExMachina.Ecto, repo: Core.Repo

  def user_factory do
    password = "password123"

    %Core.Schemas.User{
      full_name: "User Name",
      email: sequence(:email, &"user#{&1}@email.com"),
      password: password,
      password_hash: Argon2.hash_pwd_salt(password),
      base_income: 0
    }
  end

  def category_factory do
    %Core.Schemas.Category{
      user: build(:user),
      title: "Category",
      description: "Category for transactions"
    }
  end

  def transaction_factory do
    %Core.Schemas.Transaction{
      user: build(:user),
      category: build(:category),
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
