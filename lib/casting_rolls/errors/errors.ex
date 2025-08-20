defmodule CastingRolls.BadRequest do
  use CastingRolls.Error, default_message: "Bad Request", default_status: 400
end

defmodule CastingRolls.UnauthorizedError do
  use CastingRolls.Error, default_message: "Unauthorized", default_status: 401
end

defmodule CastingRolls.ForbiddenError do
  use CastingRolls.Error, default_message: "Forbidden", default_status: 403
end

defmodule CastingRolls.NotFoundError do
  use CastingRolls.Error, default_message: "Not Found", default_status: 404
end

defmodule CastingRolls.DataConflict do
  use CastingRolls.Error, default_message: "Conflict", default_status: 409
end
