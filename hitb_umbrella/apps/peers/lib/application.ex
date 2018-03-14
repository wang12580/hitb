defmodule Peers.Application do
  @moduledoc """
  The Peers Application Service.

  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = []
    opts = [strategy: :one_for_one, name: Peers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
