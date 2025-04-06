defmodule XFinances.Users.User do
  @moduledoc """
  User entity responsible for authentication and account management.

  ## Security Notes
  - Passwords are never stored directly, only the hashed version (password_hash)
  - Virtual password field is cleared after hashing
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Argon2

  @required_params [:full_name, :email]
  @optional_params [:is_active, :base_income, :password]

  @typedoc """
  User schema

  ## Fields

  - `id`: Integer primary key
  - `full_name`: User's complete name
  - `email`: Unique email address
  - `password`: Virtual field (transient)
  - `password_hash`: Argon2 hashed password
  - `is_active`: Account status flag
  - `base_income`: Monthly income in cents
  """
  @type t :: %__MODULE__{
          id: integer(),
          full_name: String.t(),
          email: String.t(),
          password: String.t() | nil,
          password_hash: String.t(),
          is_active: boolean(),
          base_income: integer() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "users" do
    field :full_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string, redact: true
    field :is_active, :boolean, default: true
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
    |> validate_password_presence()
    |> validate_password_complexity()
    |> maybe_hash_password()
    |> ensure_password_hash()
  end

  @spec validate_email_format(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_email_format(changeset) do
    changeset
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/,
      message: "must be a valid email address"
    )
    |> validate_length(:email, max: 160, message: "should be at most 160 characters")
  end

  @spec validate_password_presence(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_password_presence(changeset) do
    case get_field(changeset, :password_hash) do
      nil -> validate_required(changeset, [:password], message: "password is required")
      _existing -> changeset
    end
  end

  @spec validate_password_complexity(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_password_complexity(changeset) do
    if get_change(changeset, :password) do
      changeset
      |> validate_length(:password, min: 12, max: 64, message: "must be 12-64 characters")
      |> validate_format(:password, ~r/[A-Z]/,
        message: "must contain at least one uppercase letter"
      )
      |> validate_format(:password, ~r/[0-9]/, message: "must contain at least one digit")
    else
      changeset
    end
  end

  @spec ensure_password_hash(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp ensure_password_hash(changeset) do
    if get_field(changeset, :password_hash) do
      changeset
    else
      add_error(changeset, :password, "must be provided")
    end
  end

  @spec maybe_hash_password(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp maybe_hash_password(%{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:password_hash, hash_pwd_salt(password))
    |> delete_change(:password)
  end

  defp maybe_hash_password(changeset), do: changeset
end
