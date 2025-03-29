defmodule XFinances.Repo.Migrations.AddUserCategoriesRelationship do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :user_id, references(:users), null: false
    end
  end
end
