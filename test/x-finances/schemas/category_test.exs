defmodule Xfinances.Schemas.CategoryTest do
  alias XFinances.Schemas.Category

  use XFinances.DataCase, async: true

  import XFinances.Factory

  describe "changeset/2" do
    setup do
      user = insert(:user)

      required_params = %{
        user_id: user.id,
        title: "Test Category",
        description: "Category used in tests"
      }

      %{required_params: required_params}
    end

    test "returns valid changeset with valid attributes", %{required_params: params} do
      changeset = Category.changeset(params)
      assert changeset.valid?
    end

    for field <- [:user_id, :title] do
      test "returns invalid changeset when #{field} is missing", %{required_params: params} do
        invalid_params = Map.delete(params, unquote(field))

        changeset = Category.changeset(invalid_params)

        refute changeset.valid?
        assert "can't be blank" in errors_on(changeset)[unquote(field)]
      end
    end

    test "successfully persists valid changeset to database", %{required_params: params} do
      assert %Category{} =
               params
               |> Category.changeset()
               |> Repo.insert!()
    end
  end
end
