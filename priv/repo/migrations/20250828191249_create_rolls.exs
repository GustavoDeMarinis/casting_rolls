defmodule CastingRolls.Repo.Migrations.CreateRolls do
  use Ecto.Migration

  def change do
    create table(:rolls, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :expression, :string, null: false

      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :room_id, references(:rooms, type: :binary_id, on_delete: :delete_all), null: false

      add :result, :map, null: false
      timestamps(type: :utc_datetime_usec)
    end

    create index(:rolls, [:user_id])
    create index(:rolls, [:room_id])
  end
end
