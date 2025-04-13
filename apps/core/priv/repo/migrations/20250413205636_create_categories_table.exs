defmodule Core.Repo.Migrations.CreateCategoriesTable do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :string
      add :user_id, references(:users, on_delete: :delete_all ,type: :binary_id), null: false

      timestamps()
      end
  end
end
