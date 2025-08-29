defmodule CastingRolls.Rolls.Result do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :dice, {:array, :integer}
    embeds_many :bonus, CastingRolls.Rolls.Bonus
    field :total, :integer
  end

  def changeset(result, attrs) do
    result
    |> cast(attrs, [:dice, :total])
    |> validate_required([:dice, :total])
    |> cast_embed(:bonus, with: &CastingRolls.Rolls.Bonus.changeset/2)
  end
end
