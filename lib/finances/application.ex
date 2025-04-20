defmodule Finances.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FinancesWeb.Telemetry,
      Finances.Repo,
      {DNSCluster, query: Application.get_env(:finances, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Finances.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Finances.Finch},
      # Start a worker by calling: Finances.Worker.start_link(arg)
      # {Finances.Worker, arg},
      # Start to serve requests, typically the last entry
      FinancesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Finances.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FinancesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
