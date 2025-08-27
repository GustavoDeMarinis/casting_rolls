defmodule CastingRolls.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CastingRollsWeb.Telemetry,
      CastingRolls.Repo,
      {DNSCluster, query: Application.get_env(:casting_rolls, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CastingRolls.PubSub},
      # Start a worker by calling: CastingRolls.Worker.start_link(arg)
      # {CastingRolls.Worker, arg},
      # Start to serve requests, typically the last entry
      CastingRollsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CastingRolls.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CastingRollsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
