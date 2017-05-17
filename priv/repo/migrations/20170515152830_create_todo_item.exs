defmodule Todo.Repo.Migrations.CreateTodo.Todo.Item do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :completed, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:items, [:user_id])
  end
end
