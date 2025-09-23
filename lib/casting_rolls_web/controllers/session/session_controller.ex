defmodule CastingRollsWeb.SessionController do
  use CastingRollsWeb, :controller

  alias CastingRolls.Accounts
  alias CastingRolls.Accounts.User
  alias CastingRollsWeb.Auth

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, %User{} = user} ->
        case Auth.generate_token(user) do
          {:ok, %{token: token}} ->
            json(conn, %{
              token: token,
              user: %{
                id: user.id,
                email: user.email,
                username: user.username
              }
            })

          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: reason})
        end

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end
end
