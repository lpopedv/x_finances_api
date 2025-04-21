defmodule Finances.Factory do
  use ExMachina.Ecto, repo: Finances.Repo

  def user_factory do
    password = "password123"

    %Finances.Schemas.User{
      full_name: "User Name",
      email: sequence(:email, &"user#{&1}@email.com"),
      password: password,
      hashed_password: Argon2.hash_pwd_salt(password)
    }
  end

  def category_factory do
    %Finances.Schemas.Category{
      user: build(:user),
      title: "Category",
      description: "Category for transactions"
    }
  end
end
