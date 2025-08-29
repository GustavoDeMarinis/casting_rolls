defmodule CastingRolls.RoomsTest do
  use CastingRolls.DataCase

  alias CastingRolls.Rooms

  describe "rooms" do
    alias CastingRolls.Rooms.Room

    import CastingRolls.RoomsFixtures

    @invalid_attrs %{name: nil, deleted_at: nil, password_hash: nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{
        name: "some name",
        deleted_at: ~U[2025-08-27 18:32:00Z],
        password_hash: "some password_hash"
      }

      assert {:ok, %Room{} = room} = Rooms.create_room(valid_attrs)
      assert room.name == "some name"
      assert room.deleted_at == ~U[2025-08-27 18:32:00Z]
      assert room.password_hash == "some password_hash"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()

      update_attrs = %{
        name: "some updated name",
        deleted_at: ~U[2025-08-28 18:32:00Z],
        password_hash: "some updated password_hash"
      }

      assert {:ok, %Room{} = room} = Rooms.update_room(room, update_attrs)
      assert room.name == "some updated name"
      assert room.deleted_at == ~U[2025-08-28 18:32:00Z]
      assert room.password_hash == "some updated password_hash"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end
end
