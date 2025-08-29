defmodule CastingRolls.RollsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CastingRolls.Rolls` context.
  """

  @doc """
  Generate a roll.
  """
  def roll_fixture(attrs \\ %{}) do
    {:ok, roll} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> CastingRolls.Rolls.create_roll()

    roll
  end
end
