defmodule CastingRolls.Rolls.Roll do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rolls" do
    field :expression, :string

    belongs_to :user, CastingRolls.Accounts.User
    belongs_to :room, CastingRolls.Rooms.Room

    embeds_one :result, CastingRolls.Rolls.Result, on_replace: :update

    timestamps(type: :utc_datetime_usec)
  end

  @required_fields ~w(expression user_id room_id result)a

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> cast_embed(:result, with: &CastingRolls.Rolls.Result.changeset/2)
  end
end
