defmodule XFinances.Users.Get do
  alias XFinances.Repo
  alias XFinances.Users.User

  def by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def all, do: Repo.all(User)
end
