defmodule Core.Schemas.User do
  @moduledoc """
  User entity responsible for authentication and account management.

  ## Security Notes
  - Passwords are never stored directly, only the hashed version (password_hash)
  - Virtual password field is cleared after hashing
  """

  use Core.Schema

  import Ecto.Changeset

  @required_params [:full_name, :email, :base_income, :password]
  @optional_params []

  @typedoc """
  User schema

  ## Fields

  - `id`: UUID primary key
  - `full_name`: User's complete name
  - `email`: Unique email address
  - `password`: Virtual field (transient)
  - `password_hash`: Argon2 hashed password
  - `base_income`: Monthly income in cents
  """
  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          full_name: String.t(),
          email: String.t(),
          password: String.t(),
          base_income: integer() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "users" do
    field :full_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string, redact: true
    field :base_income, :integer

    timestamps()
  end

  @doc """
  Builds a changeset for user registration or updates.

  ## Parameters
    - user: Existing user struct or empty schema
    - params: Map with user attributes

  ## Returns
    Ecto.Changeset with all validations applied
  """

  @spec changeset(%__MODULE__{} | t(), map()) :: Ecto.Changeset.t()
  def changeset(user \\ %__MODULE__{}, params) do
    user
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> unique_constraint(:email, message: "email already registered")
    |> validate_email_format()
    |> hash_password()
  end

  @spec validate_email_format(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_email_format(changeset) do
    changeset
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/,
      message: "must be a valid email address"
    )
    |> validate_length(:email, max: 160, message: "should be at most 160 characters")
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
  end

  defp hash_password(%Ecto.Changeset{} = changeset), do: changeset
end
