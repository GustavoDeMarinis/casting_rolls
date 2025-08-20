defmodule CastingRolls.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :deleted_at, :naive_datetime
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password_hash, :deleted_at])
    |> validate_required([:email, :username, :password_hash, :deleted_at])
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
