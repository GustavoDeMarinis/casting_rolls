defmodule CastingRolls.Rolls.DiceSpec do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :amount, :integer
    field :size, :integer
  end

  @required_fields ~w(amount size)a
  def changeset(dice, attrs) do
    dice
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:amount, greater_than: 0)
    |> validate_number(:size, greater_than: 1)
  end
end
