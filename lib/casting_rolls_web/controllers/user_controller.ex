defmodule CastingRollsWeb.UserController do
  use CastingRollsWeb, :controller

  alias CastingRolls.Accounts
  alias CastingRolls.Accounts.User

  action_fallback CastingRollsWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def show_by_email(conn, %{"email" => email}) do
    user = Accounts.get_user_by_email!(email)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def update_password(conn, %{"id" => id, "password" => password}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user_password(user, %{"password" => password}) do
      {:ok, %User{}} ->
        send_resp(conn, :no_content, "")
      {:error, changeset} ->
        render(conn, :error, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
