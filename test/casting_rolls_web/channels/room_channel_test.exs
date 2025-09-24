defmodule CastingRollsWeb.RoomChannelTest do
  use CastingRollsWeb.ChannelCase, async: true

  alias CastingRolls.Rolls.Roll
  alias CastingRollsWeb.UserSocket
  alias CastingRollsWeb.RoomChannel
  alias CastingRolls.AccountsFixtures
  alias CastingRolls.RoomsFixtures

  setup do
    # Creamos dos usuarios
    user1 = AccountsFixtures.user_fixture(%{email: "a@example.com", username: "user1", password: "123456"})
    user2 = AccountsFixtures.user_fixture(%{email: "b@example.com", username: "user2", password: "123456"})

    # Creamos una room
    room = RoomsFixtures.room_fixture(%{name: "Test Room", owner_id: user1.id})

    %{user1: user1, user2: user2, room: room}
  end

  test "two users can join a room and receive new_roll events", %{user1: u1, user2: u2, room: room} do
    # Usuario 1 se conecta y hace join
    {:ok, _, socket1} =
      UserSocket
      |> socket("user_id", %{current_user: u1})
      |> subscribe_and_join(RoomChannel, "room:#{room.id}")

    # Usuario 2 se conecta y hace join
    {:ok, _, _socket2} =
      UserSocket
      |> socket("user_id", %{current_user: u2})
      |> subscribe_and_join(RoomChannel, "room:#{room.id}")

    # Usuario 1 hace un push de nuevo roll
    push(socket1, "new_roll", %{
      "roll" => %{
        "input" => %{
          "dices_to_roll" => [%{"amount" => 1, "size" => 6}],
          "bonuses" => [],
          "multipliers" => []
        }
      }
    })

    expected_user_id = u1.id
    expected_room_id = room.id
    # Asserts: el broadcast llega a todos los sockets conectados a la room
    assert_broadcast "new_roll", %{
      roll: %Roll{
        id: _,
        user_id: ^expected_user_id,
        room_id: ^expected_room_id,
        input: %CastingRolls.Rolls.Input{
          dices_to_roll: [%CastingRolls.Rolls.DiceSpec{amount: 1, size: 6}],
          bonuses: [],
          multipliers: []
        },
        result: %CastingRolls.Rolls.Result{
          breakdown: [
            %CastingRolls.Rolls.Breakdown{
              dice: "1d6",
              results: [_ | _],
              subtotal: _subtotal,
              total: _total
            }
          ],
          bonus: [],
          total: _total
        },
        inserted_at: _,
        updated_at: _
      }
    }

  end
end
