defmodule CastingRolls.Repo.Migrations.CreateRoomsUsers do
  use Ecto.Migration

  def change do
    create table(:rooms_users, primary_key: false) do
      add :room_id, references(:rooms, type: :binary_id, on_delete: :delete_all), null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
    end

    create unique_index(:rooms_users, [:room_id, :user_id])
  end
end
