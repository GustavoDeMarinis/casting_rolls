defmodule CastingRolls.Rolls.Input do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :dices_to_roll, CastingRolls.Rolls.DiceSpec
    embeds_many :bonuses, CastingRolls.Rolls.Bonus
    field :multipliers, {:array, :integer}, default: []
  end

  def changeset(input, attrs) do
    input
    |> cast(attrs, [:multipliers])
    |> cast_embed(:dices_to_roll)
    |> cast_embed(:bonuses)
  end
end
