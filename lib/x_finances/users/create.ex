defmodule XFinances.Users.Create do
  alias XFinances.Repo
  alias XFinances.Users.User

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end

