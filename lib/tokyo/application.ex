defmodule Tokyo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do

    IO.puts "Tokyo starting..."

    children = [
      # Starts a worker by calling: Tokyo.Worker.start_link(arg)
      # {Tokyo.Worker, arg}
      # {Plug.Cowboy, scheme: :http, plug: Tokyo.User, options: [port: 3000]},
      {Tokyo.Repo.ExerciseRecord, Application.get_env(:tokyo, :initial_repo_state)},
      {Plug.Cowboy, scheme: :http, plug: Tokyo.Router, options: [port: 3000]},
      # Tokyo.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tokyo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
