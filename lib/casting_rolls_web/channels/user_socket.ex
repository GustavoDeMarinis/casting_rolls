defmodule CastingRollsWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", CastingRollsWeb.RoomChannel

  @impl true
  def connect(%{"token" => "Bearer " <> token}, socket, _connect_info) do
    case CastingRollsWeb.Auth.verify_token(token) do
      {:ok, %{"sub" => user_id}} ->
        user = CastingRolls.Accounts.get_user!(user_id)
        {:ok, assign(socket, :current_user, user)}
      {:error, _reason} ->
        :error
    end
  end

  def connect(_, _socket, _connect_info), do: :error

  @impl true
  def id(socket), do: "user_socket:#{socket.assigns.current_user.id}"
end
