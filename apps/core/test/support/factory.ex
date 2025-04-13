defmodule Core.Factory do
  use ExMachina.Ecto, repo: Core.Repo

  def user_factory do
    %{
      full_name: "User Name",
      email: sequence(:email, &"user#{&1}@email.com"),
      password: "password123",
      base_income: 0
    }
  end
end
