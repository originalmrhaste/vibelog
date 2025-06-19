defmodule Viblog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ViblogWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:viblog, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Viblog.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Viblog.Finch},
      # Start a worker by calling: Viblog.Worker.start_link(arg)
      # {Viblog.Worker, arg},
      # Start to serve requests, typically the last entry
      ViblogWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Viblog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ViblogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
