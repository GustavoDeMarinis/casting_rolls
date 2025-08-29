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
    Repo.all(Roll)
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
  def get_roll!(id), do: Repo.get!(Roll, id)

  @doc """
  Creates a roll.

  ## Examples

      iex> create_roll(%{field: value})
      {:ok, %Roll{}}

      iex> create_roll(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_roll(attrs \\ %{}) do
    %Roll{}
    |> Roll.changeset(attrs)
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
end
