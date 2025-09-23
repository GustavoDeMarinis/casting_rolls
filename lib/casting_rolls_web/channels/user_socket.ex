defmodule CastingRollsWeb.UserSocket do
  use Phoenix.Socket

  alias CastingRollsWeb.Auth
  alias CastingRolls.Accounts

  ## Channels
  channel "room:*", CastingRollsWeb.RoomChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Auth.verify_token(token) do
      {:ok, claims} ->
        user_id = claims["sub"]

        case Accounts.get_user!(user_id) do
          nil ->
            :error

          user ->
            {:ok, assign(socket, :current_user, user)}
        end

      {:error, _reason} ->
        :error
    end
  end

  def connect(_, _socket, _connect_info), do: :error

  @impl true
  def id(socket), do: "user_socket:#{socket.assigns.current_user.id}"
end
