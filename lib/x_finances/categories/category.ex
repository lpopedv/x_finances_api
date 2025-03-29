defmodule XFinances.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias XFinances.Users.User

  @required_params [:user_id, :title]
  @optional_params [:description]

  schema "categories" do
    field :title, :string
    field :description, :string

    belongs_to :user, User

    timestamps()
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> assoc_constraint(:user)
  end
end
