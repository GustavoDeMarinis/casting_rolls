defmodule CastingRollsWeb.RoomController do
  use CastingRollsWeb, :controller

  alias CastingRolls.Rooms
  alias CastingRolls.Rooms.Room

  action_fallback CastingRollsWeb.FallbackController

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, :index, rooms: rooms)
  end

  def create(conn, params) do
    with {:ok, %Room{} = room} <- Rooms.create_room(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/rooms/#{room}")
      |> render(:show, room: room)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)
    render(conn, :show, room: room)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Rooms.get_room!(id)

    with {:ok, %Room{} = room} <- Rooms.update_room(room, room_params) do
      render(conn, :show, room: room)
    end
  end

  def update_password(conn, %{"id" => id, "password" => password}) do
    room = Rooms.get_room!(id)

    case Rooms.update_room_password(room, %{"password" => password}) do
      {:ok, %Room{}} ->
        send_resp(conn, :no_content, "")

      {:error, changeset} ->
        render(conn, :error, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)

    with {:ok, %Room{}} <- Rooms.delete_room(room) do
      send_resp(conn, :no_content, "")
    end
  end
end
