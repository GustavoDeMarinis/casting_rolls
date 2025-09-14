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
      user_id: roll.user_id,
      room_id: roll.room_id,
      input: %{
        dices_to_roll: Enum.map(roll.input.dices_to_roll, fn d ->
          %{
            amount: d.amount,
            size: d.size
          }
        end),
        bonuses: Enum.map(roll.input.bonuses, fn b ->
          %{
            type: b.type,
            value: b.value
          }
        end),
        multipliers: roll.input.multipliers
      },
      result: %{
        total: roll.result.total,
        bonus: Enum.map(roll.result.bonus, fn b ->
          %{
            type: b.type,
            value: b.value
          }
        end),
        breakdown: Enum.map(roll.result.breakdown, fn d ->
          %{
            dice: d.dice,
            results: d.results,
            subtotal: d.subtotal,
            total: d.total
          }
        end)
      },
      inserted_at: roll.inserted_at
    }
  end
end
