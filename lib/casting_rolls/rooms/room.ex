defmodule CastingRolls.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

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
    |> cast(attrs, [:name, :deleted_at, :owner_id, :password])
    |> validate_required([:name, :owner_id])
    |> maybe_put_password_hash()
    |> maybe_put_members(attrs)
  end

  defp maybe_put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        put_change(changeset, :password_hash, hash_password(password))
    end
  end

  defp hash_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end

  defp maybe_put_members(changeset, %{"member_ids" => ids}) when is_list(ids) do
    members =
      CastingRolls.Repo.all(
        from(u in CastingRolls.Accounts.User,
          where: u.id in ^ids
        )
      )

    put_assoc(changeset, :members, members)
  end
end
