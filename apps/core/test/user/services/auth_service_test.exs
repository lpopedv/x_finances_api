defmodule User.Services.AuthServiceTest do
  use Core.DataCase, async: true

  alias Core.User.Services.AuthService

  import Core.Factory

  describe "verify_and_get_user/2" do
    setup do
      user = insert(:user)
      %{user: user}
    end

    test "successfully authenticates a user with valid credentials", %{user: user} do
      result = Core.User.Services.AuthService.verify_and_get_user(user.email, user.password)

      full_name = user.full_name
      email = user.email
      base_income = user.base_income

      assert {:ok,
              %Core.Schemas.User{
                full_name: ^full_name,
                email: ^email,
                base_income: ^base_income
              }} = result
    end

    test "fails to authenticate a user with invalid credentials", %{user: user} do
      wrong_email =
        Core.User.Services.AuthService.verify_and_get_user("any@email.com", "password123")

      assert {:error, :invalid_credentials} = wrong_email

      wrong_password = AuthService.verify_and_get_user(user.email, "anypass")

      assert {:error, :invalid_credentials} = wrong_password
    end
  end
end
