defmodule XFinances.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @params [:title, :description]

  schema "categories" do
    field :title, :string
    field :description, :string
    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @params)
    |> validate_required([:title])
  end

  def changeset(category, params) do
    category
    |> cast(params, @params)
    |> validate_required([:title])
  end
end
