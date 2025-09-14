defmodule CastingRolls.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  import CastingRolls.Utils

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

  @required_fields [:name, :owner_id]
  @optional_fields [:deleted_at, :password]
  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> maybe_put_password_hash()
    |> maybe_put_members(attrs)
    |> validate_owner_not_in_members()
  end

  @update_fields ~w(name deleted_at owner_id)a
  def update_changeset(room, attrs) do
    room
    |> cast(attrs, @update_fields)
    |> validate_forbid_password(attrs)
    |> validate_at_least_one_change(@update_fields)
    |> maybe_put_members(attrs)
    |> validate_owner_not_in_members()
  end

  def update_password_changeset(room, attrs) do
    room
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> maybe_put_password_hash()
  end

  defp maybe_put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, hash_password(password))
    end
  end

  defp maybe_put_members(changeset, %{"member_ids" => ids}) when is_list(ids) do
    members =
      ids
      |> Enum.map(&Ecto.UUID.cast!/1)
      |> then(fn uuids ->
        CastingRolls.Repo.all(
          from u in CastingRolls.Accounts.User,
            where: u.id in ^uuids
        )
      end)

    put_assoc(changeset, :members, members)
  end

  defp maybe_put_members(changeset, _), do: changeset

  defp validate_owner_not_in_members(changeset) do
    owner_id = get_field(changeset, :owner_id)
    members = get_field(changeset, :members, [])

    if owner_id && Enum.any?(members, &(&1.id == owner_id)) do
      add_error(changeset, :members, "Owner cannot also be a member")
    else
      changeset
    end
  end
end
