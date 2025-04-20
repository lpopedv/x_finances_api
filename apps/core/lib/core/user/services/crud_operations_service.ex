defmodule Core.User.Services.CrudOperationsService do
  alias Core.Schemas.User
  alias Core.Repo

  def create(new_user_params) do
    changeset = User.changeset(%User{}, new_user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, Map.drop(user, [:password])}

      error ->
        error
    end
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

  def get_by_id(user_id) do
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
