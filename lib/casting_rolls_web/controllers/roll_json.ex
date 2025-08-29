defmodule CastingRollsWeb.RollJSON do
  alias CastingRolls.Rolls.Roll

  @doc """
  Renders a list of rolls.
  """
  def index(%{rolls: rolls}) do
    %{data: for(roll <- rolls, do: data(roll))}
  end

  @doc """
  Renders a single roll.
  """
  def show(%{roll: roll}) do
    %{data: data(roll)}
  end

  defp data(%Roll{} = roll) do
    %{
      id: roll.id,
      expression: roll.expression,
      user_id: roll.user_id,
      room_id: roll.room_id,
      result: result_data(roll.result),
      inserted_at: roll.inserted_at
    }
  end

  defp result_data(nil), do: nil

  defp result_data(result) do
    %{
      dice: result.dice,
      bonus: for(b <- result.bonus, do: %{type: b.type, value: b.value}),
      total: result.total
    }
  end
end
