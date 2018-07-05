defmodule Stat.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # import Supervisor.Spec
    # Define workers and child supervisors to be supervised
    children = [
      Stat.Task
    ]
    # worker(MyApp.Periodically, [])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Stat.Supervisor]
    supervisor = Supervisor.start_link(children, opts)


    # :erlang.start_timer(5000, test(), "test")
    supervisor
  end

  # defp test() do
  #   IO.inspect "=================="
  #   "a"
  # end

end
