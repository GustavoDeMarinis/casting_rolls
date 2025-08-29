defmodule CastingRolls.RollsTest do
  use CastingRolls.DataCase

  alias CastingRolls.Rolls

  describe "rolls" do
    alias CastingRolls.Rolls.Roll

    import CastingRolls.RollsFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_rolls/0 returns all rolls" do
      roll = roll_fixture()
      assert Rolls.list_rolls() == [roll]
    end

    test "get_roll!/1 returns the roll with given id" do
      roll = roll_fixture()
      assert Rolls.get_roll!(roll.id) == roll
    end

    test "create_roll/1 with valid data creates a roll" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Roll{} = roll} = Rolls.create_roll(valid_attrs)
      assert roll.description == "some description"
      assert roll.title == "some title"
    end

    test "create_roll/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rolls.create_roll(@invalid_attrs)
    end

    test "update_roll/2 with valid data updates the roll" do
      roll = roll_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Roll{} = roll} = Rolls.update_roll(roll, update_attrs)
      assert roll.description == "some updated description"
      assert roll.title == "some updated title"
    end

    test "update_roll/2 with invalid data returns error changeset" do
      roll = roll_fixture()
      assert {:error, %Ecto.Changeset{}} = Rolls.update_roll(roll, @invalid_attrs)
      assert roll == Rolls.get_roll!(roll.id)
    end

    test "delete_roll/1 deletes the roll" do
      roll = roll_fixture()
      assert {:ok, %Roll{}} = Rolls.delete_roll(roll)
      assert_raise Ecto.NoResultsError, fn -> Rolls.get_roll!(roll.id) end
    end

    test "change_roll/1 returns a roll changeset" do
      roll = roll_fixture()
      assert %Ecto.Changeset{} = Rolls.change_roll(roll)
    end
  end
end
