defmodule KS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KSWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:kitchensink, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: KS.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: KS.Finch},
      # Start a worker by calling: KS.Worker.start_link(arg)
      # {KS.Worker, arg},
      # Start to serve requests, typically the last entry
      KSWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KSWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
