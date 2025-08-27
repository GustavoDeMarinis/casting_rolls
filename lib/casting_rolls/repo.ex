defmodule CastingRolls.Repo do
  use Ecto.Repo,
    otp_app: :casting_rolls,
    adapter: Ecto.Adapters.Postgres
end
