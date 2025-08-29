defmodule CastingRollsWeb.RollControllerTest do
  use CastingRollsWeb.ConnCase

  import CastingRolls.RollsFixtures
  alias CastingRolls.Rolls.Roll

  @create_attrs %{
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{description: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rolls", %{conn: conn} do
      conn = get(conn, ~p"/api/rolls")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create roll" do
    test "renders roll when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/rolls", roll: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/rolls/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/rolls", roll: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update roll" do
    setup [:create_roll]

    test "renders roll when data is valid", %{conn: conn, roll: %Roll{id: id} = roll} do
      conn = put(conn, ~p"/api/rolls/#{roll}", roll: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/rolls/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, roll: roll} do
      conn = put(conn, ~p"/api/rolls/#{roll}", roll: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete roll" do
    setup [:create_roll]

    test "deletes chosen roll", %{conn: conn, roll: roll} do
      conn = delete(conn, ~p"/api/rolls/#{roll}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/rolls/#{roll}")
      end
    end
  end

  defp create_roll(_) do
    roll = roll_fixture()

    %{roll: roll}
  end
end
