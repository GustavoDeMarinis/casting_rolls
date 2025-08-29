defmodule CastingRolls.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CastingRolls.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        deleted_at: ~U[2025-08-27 18:32:00Z],
        name: "some name",
        password_hash: "some password_hash"
      })
      |> CastingRolls.Rooms.create_room()

    room
  end
end
