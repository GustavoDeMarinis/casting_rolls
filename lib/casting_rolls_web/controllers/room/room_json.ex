defmodule CastingRollsWeb.RoomJSON do
  alias CastingRolls.Accounts.User
  alias CastingRolls.Rooms.Room

  @doc """
  Renders a list of rooms.
  """
  def index(%{rooms: rooms}) do
    %{data: for(room <- rooms, do: data(room))}
  end

  @doc """
  Renders a single room.
  """
  def show(%{room: room}) do
    %{data: data(room)}
  end

  defp data(%Room{} = room) do
    %{
      id: room.id,
      name: room.name,
      deleted_at: room.deleted_at,
      owner: maybe_user(room.owner),
      members: Enum.map(room.members, &maybe_user/1)
    }
  end

  defp maybe_user(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email
    }
  end

  defp maybe_user(nil), do: nil
end
