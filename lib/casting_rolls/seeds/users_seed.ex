alias CastingRolls.Repo
alias CastingRolls.Accounts
alias CastingRolls.Accounts.User

defmodule CastingRolls.Seed.Users do
  @users [
    %{email: "gustadema@gmail.com", username: "gustavoDm", password: "@1234"},
    %{email: "alice@example.com", username: "alice", password: "password123"},
    %{email: "rodrigo@example.com", username: "rodrigo", password: "password123"},
    %{email: "fernando@example.com", username: "fernando", password: "password123"},
    %{email: "federico@example.com", username: "federico", password: "password123"}
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
