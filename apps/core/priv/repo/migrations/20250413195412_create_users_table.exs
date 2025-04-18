defmodule Core.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :full_name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :base_income, :integer

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
