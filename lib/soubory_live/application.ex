defmodule SouboryLive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: SouboryLive.ZipDynamicSupervisor},
      # Start the Telemetry supervisor
      SouboryLiveWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SouboryLive.PubSub},
      # Start the Endpoint (http/https)
      SouboryLiveWeb.Endpoint,
      # Start a worker by calling: SouboryLive.Worker.start_link(arg)
      # {SouboryLive.Worker, arg}
      SouboryLive.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SouboryLive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SouboryLiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
