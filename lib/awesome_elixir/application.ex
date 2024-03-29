defmodule AwesomeElixir.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: AwesomeElixir.PubSub},
      # Start the Endpoint (http/https)
      AwesomeElixirWeb.Endpoint,
      # Start a worker by calling: AwesomeElixir.Worker.start_link(arg)
      # {AwesomeElixir.Worker, arg}
      AwesomeElixir.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AwesomeElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AwesomeElixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
