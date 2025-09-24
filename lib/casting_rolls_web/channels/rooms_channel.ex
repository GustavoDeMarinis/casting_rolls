# lib/casting_rolls_web/channels/room_channel.ex
defmodule CastingRollsWeb.RoomChannel do
  use Phoenix.Channel
  alias CastingRolls.Rolls
  alias CastingRolls.Rolls.Roll
  alias CastingRolls.Repo

  @impl true
  def join("room:" <> room_id, _params, socket) do
    user = socket.assigns.current_user

    # Verificamos que el usuario sea parte del room (opcional)
    case Repo.get(CastingRolls.Rooms.Room, room_id) do
      nil ->
        {:error, %{reason: "Room not found"}}

      room ->
        {:ok, assign(socket, :room_id, room.id)}
    end
  end

  @impl true
  def handle_in("new_roll", %{"roll" => %{"input" => input_params}}, socket) do
    user = socket.assigns.current_user
    room_id = socket.assigns.room_id

    params = %{
      "input" => input_params,
      "user_id" => user.id,
      "room_id" => room_id
    }

    case Rolls.create_roll(params) do
      {:ok, %Roll{} = roll} ->
        broadcast!(socket, "new_roll", %{roll: roll})
        {:reply, {:ok, %{roll: roll}}, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

end
