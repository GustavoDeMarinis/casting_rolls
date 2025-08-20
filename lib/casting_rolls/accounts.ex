defmodule CastingRolls.Accounts do
  @moduledoc """
  The Accounts context: responsible for user management, authentication,
  and related business logic. All errors raise structured exceptions with
  HTTP status codes for consistent handling in controllers.
  """

  import Ecto.Query, warn: false
  alias CastingRolls.Repo
  alias CastingRolls.Accounts.User
  alias CastingRolls.ForbiddenError
  alias CastingRolls.AuthErrors


  @doc """
  Returns the list of all users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user by ID.

  Raises `CastingRolls.ForbiddenError` if the User does not exist.
  """
  def get_user!(id) do
    Repo.get(User, id) || AuthErrors.invalid_credentials!()
  end

  @doc """
  Creates a user with the given attributes.
  """
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Gets a single user by email.

  Raises `CastingRolls.ForbiddenError` for invalid credentials.
  """
  def get_user_by_email!(email) do
    Repo.get_by(User, email: email) || raise ForbiddenError.new("Invalid credentials")
  end

  @doc """
  Authenticates a user by email and password.

  Raises `CastingRolls.ForbiddenError` for invalid credentials.
  """
  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        {:ok, user}

      true ->
        raise ForbiddenError.new("Invalid credentials")
    end
  end
end
