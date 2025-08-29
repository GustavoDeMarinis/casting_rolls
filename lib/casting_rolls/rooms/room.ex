defmodule CastingRolls.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rooms" do
    field :name, :string
    field :deleted_at, :utc_datetime_usec
    field :password, :string, virtual: true
    field :password_hash, :string

    belongs_to :owner, CastingRolls.Accounts.User,
      foreign_key: :owner_id,
      type: :binary_id

    many_to_many :members, CastingRolls.Accounts.User,
      join_through: "rooms_users",
      on_replace: :delete

    has_many :rolls, CastingRolls.Rolls.Roll

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :deleted_at, :password_hash])
    |> validate_required([:name, :deleted_at, :password_hash])
  end
end
