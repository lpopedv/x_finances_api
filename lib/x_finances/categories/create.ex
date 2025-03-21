defmodule XFinances.Categories.Create do
  alias XFinances.Repo
  alias XFinances.Categories.Category

  def call(params) do
    params
    |> Category.changeset()
    |> Repo.insert()
  end
end
