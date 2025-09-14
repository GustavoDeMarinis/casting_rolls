defmodule CastingRolls.Rolls do
  @moduledoc """
  The Rolls context.
  """

  import Ecto.Query, warn: false
  alias CastingRolls.Repo
  alias CastingRolls.Rolls.Roll
  @doc """
  Returns the list of rolls.

  ## Examples

      iex> list_rolls()
      [%Roll{}, ...]

  """
  def list_rolls do
    Repo.all(Roll) |> Repo.preload([:user, :room])
  end

  @doc """
  Gets a single roll.

  Raises `Ecto.NoResultsError` if the Roll does not exist.

  ## Examples

      iex> get_roll!(123)
      %Roll{}

      iex> get_roll!(456)
      ** (Ecto.NoResultsError)

  """
  def get_roll!(id), do: Repo.get!(Roll, id) |> Repo.preload([:user, :room])

  @doc """
  Creates a roll.

  ## Examples

      iex> create_roll(%{field: value})
      {:ok, %Roll{}}

      iex> create_roll(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_roll(attrs) do
    %Roll{}
    |> Roll.changeset(attrs)
    |> Ecto.Changeset.put_embed(:result, compute_result(attrs["input"] || attrs[:input]))
    |> Repo.insert()
  end

  @doc """
  Updates a roll.

  ## Examples

      iex> update_roll(roll, %{field: new_value})
      {:ok, %Roll{}}

      iex> update_roll(roll, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_roll(%Roll{} = roll, attrs) do
    roll
    |> Roll.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a roll.

  ## Examples

      iex> delete_roll(roll)
      {:ok, %Roll{}}

      iex> delete_roll(roll)
      {:error, %Ecto.Changeset{}}

  """
  def delete_roll(%Roll{} = roll) do
    Repo.delete(roll)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking roll changes.

  ## Examples

      iex> change_roll(roll)
      %Ecto.Changeset{data: %Roll{}}

  """
  def change_roll(%Roll{} = roll, attrs \\ %{}) do
    Roll.changeset(roll, attrs)
  end

  defp compute_result(nil), do: nil

  defp compute_result(%{
         "dices_to_roll" => dices,
         "bonuses" => bonuses,
         "multipliers" => multipliers
       }) do
    # para cada dice spec hacemos las tiradas y armamos un Breakdown
    breakdowns =
      Enum.map(dices, fn %{"amount" => amount, "size" => size} ->
        rolls = Enum.map(1..amount, fn _ -> :rand.uniform(size) end)

        %CastingRolls.Rolls.Breakdown{
          dice: "#{amount}d#{size}",
          results: rolls,
          subtotal: Enum.sum(rolls),
          # por ahora total igual al subtotal; luego se suman bonuses
          total: Enum.sum(rolls)
        }
      end)

    subtotal = breakdowns |> Enum.map(& &1.subtotal) |> Enum.sum()

    # convertir bonuses a structs
    bonus_structs =
      Enum.map(bonuses || [], fn %{"type" => type, "value" => val} ->
        %CastingRolls.Rolls.Bonus{type: type, value: val}
      end)

    after_bonus =
      Enum.reduce(bonus_structs, subtotal, fn b, acc -> acc + b.value end)

    final_total =
      Enum.reduce(multipliers || [], after_bonus, fn mult, acc -> acc * mult end)

    # actualizar total en cada breakdown
    breakdowns = Enum.map(breakdowns, fn d -> %{d | total: d.subtotal} end)

    %CastingRolls.Rolls.Result{
      total: final_total,
      breakdown: breakdowns,
      bonus: bonus_structs
    }
  end
end
