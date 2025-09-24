defmodule CastingRollsWeb.Plugs.AuthPlug do
  import Plug.Conn
  alias CastingRollsWeb.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Auth.verify_token(token) do
      assign(conn, :current_user_id, claims["sub"])
    else
      _ ->
        conn
        |> send_resp(:unauthorized, "Unauthorized")
        |> halt()
    end
  end
end
