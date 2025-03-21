defmodule XFinances.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :category_id, references(:categories, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :movement, :string, null: false
      add :value_in_cents, :integer, null: false
      add :date, :date
      add :due_date, :date
      add :is_fixed, :boolean, default: false, null: false
      add :is_paid, :boolean, default: false, null: false

      timestamps()
    end
  end
end
