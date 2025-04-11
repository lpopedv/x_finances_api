defmodule XFinances.GenAuthToken do
  def call(user) do
    user_data = %{
      id: user.id,
      full_name: user.full_name,
      email: user.email,
      base_income: user.base_income
    }

    XFinances.Auth.UserToken.sign(user_data)
  end
end
