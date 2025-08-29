defmodule CastingRolls.Rolls.Bonus do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :type, :string
    field :value, :integer
  end

  def changeset(bonus, attrs) do
    bonus
    |> cast(attrs, [:type, :value])
    |> validate_required([:type, :value])
  end
end
