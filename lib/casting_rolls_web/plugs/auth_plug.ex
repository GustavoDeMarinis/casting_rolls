defmodule CastingRollsWeb.Plugs.AuthPlug do
  import Plug.Conn
  alias CastingRollsWeb.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    IO.inspect(get_req_header(conn, "authorization"))
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      IO.inspect(token, label: "Token"),
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
