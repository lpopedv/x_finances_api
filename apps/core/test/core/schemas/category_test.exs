defmodule Core.Schemas.CategoryTest do
  use Core.DataCase, async: true

  import Core.Factory

  alias Core.Schemas.Category

  describe "changeset/2" do
    setup do
      user = insert(:user)

      required_params = %{
        user_id: user.id,
        title: "Category"
      }

      %{required_params: required_params}
    end

    test "returns valid changeset with valid attributes", %{required_params: required_params} do
      changeset = Category.changeset(required_params)
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

    test "returns invalid changeset when title length < 3", %{required_params: required_params} do
      invalid_params = %{required_params | title: "ab"}

      changeset = Category.changeset(invalid_params)

      refute changeset.valid?

      assert "should be at least 3 character(s)" in errors_on(changeset)[unquote(:title)]
    end

    test "returns invalid changeset when title length > 50", %{required_params: required_params} do
      invalid_params = %{required_params | title: String.duplicate("a", 51)}

      changeset = Category.changeset(invalid_params)

      refute changeset.valid?

      assert "should be at most 50 character(s)" in errors_on(changeset)[unquote(:title)]
    end

    test "returns invalid changeset when description length > 255", %{
      required_params: required_params
    } do
      invalid_params = Map.merge(required_params, %{description: String.duplicate("a", 256)})

      changeset = Category.changeset(invalid_params)

      refute changeset.valid?

      assert "should be at most 255 character(s)" in errors_on(changeset)[unquote(:description)]
    end
  end
end
