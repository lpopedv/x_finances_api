defmodule XFinances.Repo.Migrations.AddUserTransactionsRelationship do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :user_id, references(:users), null: false
    end
  end
end
