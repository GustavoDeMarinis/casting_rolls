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

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :deleted_at])
    |> validate_forbid_password(attrs)
    |> validate_at_least_one_change([:email, :username, :deleted_at])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  def update_password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    if pw = get_change(changeset, :password) do
      put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pw))
    else
      changeset
    end
  end

  defp validate_forbid_password(changeset, attrs) do
    if Map.has_key?(attrs, "password") or Map.has_key?(attrs, :password) do
      add_error(changeset, :password, "Password cannot be updated here")
    else
      changeset
    end
  end

  defp validate_at_least_one_change(changeset, allowed_fields) do
    IO.puts("Validating at least one change in #{inspect(changeset.errors)}")
    if Enum.any?(allowed_fields, &Map.has_key?(changeset.changes, &1)) || changeset.errors != [] do
      changeset
    else
      add_error(changeset, :base, "At least one field must be provided for update")
    end
  end

end
