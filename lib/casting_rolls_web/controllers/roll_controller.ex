defmodule CastingRollsWeb.RollController do
  use CastingRollsWeb, :controller

  alias CastingRolls.Rolls
  alias CastingRolls.Rolls.Roll

  action_fallback CastingRollsWeb.FallbackController

  def index(conn, _params) do
    rolls = Rolls.list_rolls()
    render(conn, :index, rolls: rolls)
  end

  def create(conn, %{"roll" => roll_params}) do
    with {:ok, %Roll{} = roll} <- Rolls.create_roll(roll_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/rolls/#{roll}")
      |> render(:show, roll: roll)
    end
  end

  def show(conn, %{"id" => id}) do
    roll = Rolls.get_roll!(id)
    render(conn, :show, roll: roll)
  end

  def update(conn, %{"id" => id, "roll" => roll_params}) do
    roll = Rolls.get_roll!(id)

    with {:ok, %Roll{} = roll} <- Rolls.update_roll(roll, roll_params) do
      render(conn, :show, roll: roll)
    end
  end

  def delete(conn, %{"id" => id}) do
    roll = Rolls.get_roll!(id)

    with {:ok, %Roll{}} <- Rolls.delete_roll(roll) do
      send_resp(conn, :no_content, "")
    end
  end
end
