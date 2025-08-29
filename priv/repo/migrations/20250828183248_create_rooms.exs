defmodule CastingRolls.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :deleted_at, :utc_datetime
      add :password_hash, :string
      add :owner_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:rooms, [:owner_id])
  end
end
