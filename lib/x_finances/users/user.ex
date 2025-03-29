defmodule XFinances.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:full_name, :email, :password]
  @optional_params [:is_active, :base_income]

  schema "users" do
    field :full_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string, redact: true
    field :is_active, :boolean, default: true
    field :base_income, :integer

    timestamps()
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> unique_constraint(:email)
    |> validate_password()
    |> maybe_hash_password()
  end

  defp validate_password(%{data: %{password_hash: nil}} = changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
  end

  defp validate_password(changeset), do: changeset

  defp maybe_hash_password(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       )
       when is_binary(password) do
    put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
  end

  defp maybe_hash_password(changeset), do: changeset
end
