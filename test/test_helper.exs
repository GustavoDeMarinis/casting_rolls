ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(CastingRolls.Repo, :manual)

Enum.each(Path.wildcard("#{__DIR__}/support/**/*.ex"), &Code.require_file/1)
