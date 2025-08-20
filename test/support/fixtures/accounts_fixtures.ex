defmodule CastingRolls.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CastingRolls.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user username.
  """
  def unique_user_username, do: "some username#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        deleted_at: ~N[2025-08-18 17:43:00],
        email: unique_user_email(),
        inserted_at: ~N[2025-08-18 17:43:00],
        password_hash: "some password_hash",
        updated_at: ~N[2025-08-18 17:43:00],
        username: unique_user_username()
      })
      |> CastingRolls.Accounts.create_user()

    user
  end
end
