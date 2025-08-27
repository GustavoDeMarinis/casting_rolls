defmodule CastingRollsWeb.UserJSON do
  alias CastingRolls.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      username: user.username,
      password: user.password,
      password_hash: user.password_hash,
      deleted_at: user.deleted_at
    }
  end
end
