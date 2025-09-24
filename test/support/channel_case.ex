defmodule CastingRollsWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import helpers for testing channels
      import Phoenix.ChannelTest
      import CastingRollsWeb.ChannelCase

      # The default endpoint for testing
      @endpoint CastingRollsWeb.Endpoint
    end
  end

  setup tags do
    # Checkout a sandboxed connection
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CastingRolls.Repo)

    unless tags[:async] do
      # Shared mode for non-async tests
      Ecto.Adapters.SQL.Sandbox.mode(CastingRolls.Repo, {:shared, self()})
    end

    :ok
  end
end
