defmodule CastingRolls.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

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

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :email, :username, :password, :deleted_at])
    |> validate_required([:email, :username, :password])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    if pw = get_change(changeset, :password) do
      put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pw))
    else
      changeset
    end
  end
end
