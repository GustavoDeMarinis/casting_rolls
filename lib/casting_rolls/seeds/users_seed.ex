alias CastingRolls.Repo
alias CastingRolls.Accounts
alias CastingRolls.Accounts.User
alias CastingRolls.Seed.GlobalIds

defmodule CastingRolls.Seed.Users do

  @default_password "password123"


  @users [
    %{
      id: GlobalIds.user_gustavo_id(),
      email: "gustadema@gmail.com",
      username: "gustavoDm",
      password: @default_password
    },
    %{
      id: GlobalIds.user_alice_id(),
      email: "alice@example.com",
      username: "alice",
      password: @default_password
    },
    %{
      id: GlobalIds.user_rodrigo_id(),
      email: "rodrigo@example.com",
      username: "rodrigo",
      password: @default_password
    },
    %{
      id: GlobalIds.user_fernando_id(),
      email: "fernando@example.com",
      username: "fernando",
      password: @default_password
    },
    %{
      id: GlobalIds.user_federico_id(),
      email: "federico@example.com",
      username: "federico",
      password: @default_password
    }
  ]

  def run do
    Enum.each(@users, fn attrs ->
      case Accounts.get_user_by_email(attrs.email) do
        nil ->
          %User{}
          |> User.changeset(attrs)
          |> Repo.insert!()

        _ ->
          :ok
      end
    end)
  end
end
