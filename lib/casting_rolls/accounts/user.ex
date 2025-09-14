defmodule CastingRolls.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import CastingRolls.Utils

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :deleted_at, :utc_datetime
    timestamps()
  end

  @required_fields ~w(email username password)a
  @optional_fields ~w(id)a
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  @update_fields ~w(email username deleted_at)a
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, @update_fields)
    |> validate_forbid_password(attrs)
    |> validate_at_least_one_change(@update_fields)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  def update_password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> put_password_hash()
  end
end
