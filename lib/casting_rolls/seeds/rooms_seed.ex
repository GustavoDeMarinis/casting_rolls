alias CastingRolls.Repo
alias CastingRolls.Rooms.Room
alias CastingRolls.Seed.GlobalIds

defmodule CastingRolls.Seed.Rooms do
  @rooms [
    %{
      name: "Room Owned By Gustavo",
      owner_id: GlobalIds.user_gustavo_id(),
      member_ids: [GlobalIds.user_alice_id(), GlobalIds.user_rodrigo_id()]
    },
    %{
      name: "Room Owned By Dorri",
      owner_id: GlobalIds.user_rodrigo_id(),
      member_ids: [GlobalIds.user_fernando_id(), GlobalIds.user_federico_id()]
    },
    %{
      name: "Room Owned By Fer",
      owner_id: GlobalIds.user_fernando_id(),
      member_ids: [GlobalIds.user_gustavo_id(), GlobalIds.user_federico_id()]
    },
    %{
      name: "Room Owned By Fede",
      owner_id: GlobalIds.user_federico_id(),
      member_ids: [GlobalIds.user_alice_id(), GlobalIds.user_fernando_id()]
    },
    %{
      name: "Room Owned By Alicia",
      owner_id: GlobalIds.user_alice_id(),
      member_ids: [GlobalIds.user_gustavo_id(), GlobalIds.user_rodrigo_id()]
    }
  ]

  def run do
    Enum.each(@rooms, fn attrs ->
      %Room{}
      |> Room.changeset(attrs)
      |> Repo.insert!()
    end)
  end
end
