defmodule CastingRollsWeb.RoomControllerTest do
  use CastingRollsWeb.ConnCase

  import CastingRolls.RoomsFixtures
  alias CastingRolls.Rooms.Room

  @create_attrs %{
    name: "some name",
    deleted_at: ~U[2025-08-27 18:32:00Z],
    password_hash: "some password_hash"
  }
  @update_attrs %{
    name: "some updated name",
    deleted_at: ~U[2025-08-28 18:32:00Z],
    password_hash: "some updated password_hash"
  }
  @invalid_attrs %{name: nil, deleted_at: nil, password_hash: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get(conn, ~p"/api/rooms")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create room" do
    test "renders room when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/rooms", room: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/rooms/#{id}")

      assert %{
               "id" => ^id,
               "deleted_at" => "2025-08-27T18:32:00Z",
               "name" => "some name",
               "password_hash" => "some password_hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/rooms", room: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update room" do
    setup [:create_room]

    test "renders room when data is valid", %{conn: conn, room: %Room{id: id} = room} do
      conn = put(conn, ~p"/api/rooms/#{room}", room: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/rooms/#{id}")

      assert %{
               "id" => ^id,
               "deleted_at" => "2025-08-28T18:32:00Z",
               "name" => "some updated name",
               "password_hash" => "some updated password_hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = put(conn, ~p"/api/rooms/#{room}", room: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete room" do
    setup [:create_room]

    test "deletes chosen room", %{conn: conn, room: room} do
      conn = delete(conn, ~p"/api/rooms/#{room}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/rooms/#{room}")
      end
    end
  end

  defp create_room(_) do
    room = room_fixture()

    %{room: room}
  end
end
