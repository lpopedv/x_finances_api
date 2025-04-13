defmodule Core.Schemas.Transaction do
  @moduledoc """
  Financial transaction entity representing money movements.

  ## Relationships
  - Belongs to a user
  - Belongs to a category
  """

  use Core.Schema

  import Ecto.Changeset

  alias Core.Schemas.Category
  alias Core.Schemas.User

  @movement_types [:incoming, :outgoing]

  @required_params [
    :category_id,
    :user_id,
    :title,
    :movement,
    :value_in_cents
  ]
  @optional_params [:date, :due_date, :is_fixed, :is_paid]

  @typedoc """
  Transaction schema

  ## Fields

  - `id`: UUID primary key
  - `title`: Transaction description
  - `movement`: :incoming or :outgoing (Ecto.Enum)
  - `value_in_cents`: Transaction amount in cents
  - `date`: Effective date
  - `due_date`: Due date
  - `is_fixed`: Recurring transaction flag
  - `is_paid`: Payment status
  - `user_id`: Owner reference
  - `category_id`: Category reference
  """
  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          title: String.t(),
          movement: :incoming | :outgoing,
          value_in_cents: integer(),
          date: Date.t() | nil,
          due_date: Date.t() | nil,
          is_fixed: boolean(),
          is_paid: boolean(),
          category_id: Ecto.UUID.t(),
          user_id: Ecto.UUID.t(),
          category: Category.t() | Ecto.Association.NotLoaded.t(),
          user: User.t() | Ecto.Association.NotLoaded.t(),
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "transactions" do
    field :title, :string
    field :movement, Ecto.Enum, values: @movement_types
    field :value_in_cents, :integer
    field :date, :date
    field :due_date, :date
    field :is_fixed, :boolean, default: false
    field :is_paid, :boolean, default: false

    belongs_to :user, User
    belongs_to :category, Category

    timestamps()
  end

  @doc """
  Builds a changeset for transaction creation or updates.

  ## Parameters
    - transaction: Existing transaction struct or empty schema
    - params: Map with transaction attributes

  ## Returns
    Ecto.Changeset with all validations applied
  """
  @spec changeset(%__MODULE__{} | t(), map()) :: Ecto.Changeset.t()
  def changeset(transaction \\ %__MODULE__{}, params) do
    transaction
    |> cast(params, @optional_params ++ @required_params)
    |> validate_required(@required_params)
    |> validate_length(:title, min: 3, max: 100)
    |> validate_number(:value_in_cents, greater_than: 0)
    |> validate_dates()
    |> assoc_constraint(:user)
    |> assoc_constraint(:category)
  end

  @spec validate_dates(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_dates(changeset) do
    changeset
    |> validate_date_not_past(:due_date)
    |> validate_date_consistency()
  end

  @spec validate_date_not_past(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  defp validate_date_not_past(changeset, field) do
    case get_change(changeset, field) do
      nil ->
        changeset

      date ->
        if Date.compare(date, Date.utc_today()) == :lt,
          do: add_error(changeset, field, "cannot be in the past"),
          else: changeset
    end
  end

  @spec validate_date_consistency(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_date_consistency(changeset) do
    date = get_change(changeset, :date)
    due_date = get_change(changeset, :due_date)

    cond do
      is_nil(date) or is_nil(due_date) ->
        changeset

      Date.compare(date, due_date) == :gt ->
        add_error(changeset, :date, "cannot be after due date")

      true ->
        changeset
    end
  end
end
