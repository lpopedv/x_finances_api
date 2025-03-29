defmodule XFinances.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :full_name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :is_active, :boolean
      add :base_income, :integer

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
