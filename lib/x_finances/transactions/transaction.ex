defmodule XFinances.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias XFinances.Categories.Category
  alias XFinances.Users.User

  @movement_types [:incoming, :outgoing]

  @required_params [
    :category_id,
    :user_id,
    :title,
    :movement,
    :value_in_cents,
    :is_fixed,
    :is_paid
  ]
  @optional_params [:date, :due_date]

  @type t :: %__MODULE__{
          id: integer(),
          category_id: integer(),
          user_id: integer(),
          title: String.t(),
          movement: String.t(),
          value_in_cents: String.t(),
          date: Date.t() | nil,
          due_date: Date.t() | nil,
          is_fixed: boolean(),
          is_paid: boolean(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
  schema "transactions" do
    field :title, :string
    field :movement, Ecto.Enum, values: @movement_types
    field :value_in_cents, :integer
    field :date, :date
    field :due_date, :date
    field :is_fixed, :boolean
    field :is_paid, :boolean

    belongs_to :user, User
    belongs_to :category, Category

    timestamps()
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @optional_params ++ @required_params)
    |> validate_required(@required_params)
    |> assoc_constraint(:user)
    |> assoc_constraint(:category)
  end
end
