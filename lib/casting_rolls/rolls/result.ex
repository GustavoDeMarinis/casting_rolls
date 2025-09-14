defmodule CastingRolls.Rolls.Result do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :breakdown, CastingRolls.Rolls.Breakdown
    embeds_many :bonus, CastingRolls.Rolls.Bonus
    field :total, :integer
  end

  @required_fields ~w(total)a
  def changeset(result, attrs) do
    result
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> cast_embed(:breakdown, with: &CastingRolls.Rolls.Breakdown.changeset/2)
    |> cast_embed(:bonus, with: &CastingRolls.Rolls.Bonus.changeset/2)
  end
end
