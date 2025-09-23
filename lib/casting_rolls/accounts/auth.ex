defmodule CastingRollsWeb.Auth do
  use Joken.Config

  alias CastingRolls.Accounts.User

  @issuer "casting_rolls"
  @ttl_seconds 86_400 # 24h


  @impl true
  def token_config do
    Joken.Config.default_claims(skip: [:aud])
    |> Joken.Config.add_claim("iss", fn -> @issuer end, &(&1 == @issuer))
  end

  def generate_token(%User{} = user) do
    now = System.system_time(:second)
    exp = now + @ttl_seconds

    claims = %{
      "sub" => to_string(user.id),
      "iat" => now,
      "exp" => exp,
      "iss" => @issuer
    }

    case generate_and_sign(claims, signer!()) do
      {:ok, token, _claims} -> {:ok, %{token: token}}
      {:error, reason} -> {:error, reason}
    end
  end

  defp signer! do
    secret =
      System.get_env("JWT_SECRET_KEY") ||
        raise "environment variable JWT_SECRET_KEY is missing. Export it or use direnv."

    # HS256 con la secret (string)
    Joken.Signer.create("HS256", secret)
  end

  def verify_token(token) do
    IO.inspect(Joken.verify_and_validate(token_config(), token, signer!()))
    Joken.verify_and_validate(token_config(), token, signer!())
  end
end
