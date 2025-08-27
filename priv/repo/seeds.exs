# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CastingRolls.Repo.insert!(%CastingRolls.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Seed.All do
  def run do
    CastingRolls.Seeds.Users.run()
  end
end

Seed.All.run()
IO.puts("✅ Users seeded successfully!")
