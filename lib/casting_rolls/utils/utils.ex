defmodule CastingRolls.Utils do
  use Ecto.Schema
  import Ecto.Changeset

  def hash_password(password), do: Bcrypt.hash_pwd_salt(password)

  def put_password_hash(changeset) do
    if pw = get_change(changeset, :password) do
      put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pw))
    else
      changeset
    end
  end

  def validate_forbid_password(changeset, attrs) do
    if Map.has_key?(attrs, "password") or Map.has_key?(attrs, :password) do
      add_error(changeset, :password, "Password cannot be updated here")
    else
      changeset
    end
  end

  def validate_at_least_one_change(changeset, allowed_fields) do
    if Enum.any?(allowed_fields, &Map.has_key?(changeset.changes, &1)) || changeset.errors != [] do
      changeset
    else
      add_error(changeset, :base, "At least one field must be provided for update")
    end
  end
end
