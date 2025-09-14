defmodule CastingRolls.Rolls.Breakdown do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :dice, :string
    field :results, {:array, :integer}
    field :subtotal, :integer
    field :total, :integer
  end

  @required_fields ~w(dice results subtotal total)a
  def changeset(breakdown, attrs) do
    breakdown
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
