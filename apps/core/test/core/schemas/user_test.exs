defmodule Core.Schemas.UserTest do
  use Core.DataCase, async: true

  import Core.Factory

  alias Core.Schemas.User

  describe "changeset/2" do
    setup do
      required_params = %{
        full_name: "John Doe",
        email: "john.doe@example.com",
        base_income: 500_000,
        password: "password123"
      }

      %{required_params: required_params}
    end

    test "returns valid changeset with valid attributes", %{required_params: required_params} do
      changeset = User.changeset(required_params)
      assert changeset.valid?
    end

    for field <- [:full_name, :email, :base_income] do
      test "returns invalid changeset when #{field} is missing", %{required_params: params} do
        invalid_params = Map.delete(params, unquote(field))

        changeset = User.changeset(invalid_params)

        refute changeset.valid?
        assert "can't be blank" in errors_on(changeset)[unquote(field)]
      end
    end

    test "returns invalid changeset when email is invalid", %{required_params: params} do
      invalid_params = Map.put(params, :email, "invalid_email")

      changeset = User.changeset(invalid_params)

      refute changeset.valid?
      assert "must be a valid email address" in errors_on(changeset)[:email]
    end

    test "returns invalid changeset when email not unique", %{required_params: params} do
      user = insert(:user)

      duplicate_changeset = User.changeset(%User{}, %{params | email: user.email})

      {:error, changeset} = Core.Repo.insert(duplicate_changeset)

      refute changeset.valid?
      assert "email already registered" in errors_on(changeset)[:email]
    end

    test "check if password is hashed", %{required_params: required_params} do
      password = required_params.password || "password123"

      user =
        %User{}
        |> User.changeset(required_params)
        |> Core.Repo.insert!()

      assert user.password_hash != nil
      assert Argon2.verify_pass(password, user.password_hash)
    end

    test "successfully persists valid changeset to database", %{required_params: params} do
      assert %User{} =
               params
               |> User.changeset()
               |> Repo.insert!()
    end
  end
end
