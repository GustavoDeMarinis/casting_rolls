defmodule CastingRolls.Rolls.Bonus do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :type, :string
    field :value, :integer
  end

  @required_fields ~w(type value)a
  def changeset(bonus, attrs) do
    bonus
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
