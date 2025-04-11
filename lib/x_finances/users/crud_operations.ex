defmodule XFinances.Users.CrudOperations do
  alias XFinances.Schemas.User
  alias XFinances.Repo

  def create(new_user_params) do
    new_user_params
    |> User.changeset()
    |> Repo.insert()
  end

  def update(user_id, new_user_params) do
    case Repo.get(User, user_id) do
      nil ->
        {:error, :not_found}

      user ->
        user
        |> User.changeset(new_user_params)
        |> Repo.update()
    end
  end

  def delete(user_id) do
    case Repo.get(User, user_id) do
      nil -> {:error, :not_found}
      user -> Repo.delete(user)
    end
  end

  def show(user_id) do
    case Repo.get(User, user_id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def list, do: Repo.all(User)

  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
