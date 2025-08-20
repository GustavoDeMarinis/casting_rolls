defmodule CastingRolls.AuthErrors do
  alias CastingRolls.ForbiddenError

  def invalid_credentials! do
    raise ForbiddenError.new("Invalid credentials")
  end
end
