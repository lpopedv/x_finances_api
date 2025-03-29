defmodule XFinances.Users.Delete do
  alias XFinances.Users.User
  alias XFinances.Repo

  def call(user_id) do
    case Repo.get(User, user_id) do
      nil -> {:error, :not_found}
      user -> Repo.delete(user)
    end
  end
end
