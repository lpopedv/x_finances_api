defmodule XFinances.Schemas.Category do
  @moduledoc """
  Category entity for organizing financial transactions.

  ## Relationships
  - Belongs to a user
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias XFinances.Users.User

  @required_params [:user_id, :title]
  @optional_params [:description]

  @typedoc """
  Category schema

  ## Fields

  - `id`: Integer primary key
  - `title`: Category name
  - `description`: Optional details
  - `user_id`: Owner reference
  - `user`: Associated user
  """
  @type t :: %__MODULE__{
          id: integer(),
          title: String.t(),
          description: String.t() | nil,
          user_id: integer(),
          user: User.t() | Ecto.Association.NotLoaded.t(),
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "categories" do
    field :title, :string
    field :description, :string

    belongs_to :user, User

    timestamps()
  end

  @doc """
  Builds a changeset for category creation or updates.

  ## Parameters
    - category: Existing category struct or empty schema
    - params: Map with category attributes

  ## Returns
    Ecto.Changeset with all validations applied
  """
  @spec changeset(%__MODULE__{} | t(), map()) :: Ecto.Changeset.t()
  def changeset(category \\ %__MODULE__{}, params) do
    category
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> validate_length(:title, min: 3, max: 50)
    |> validate_length(:description, max: 255)
    |> assoc_constraint(:user)
  end
end
