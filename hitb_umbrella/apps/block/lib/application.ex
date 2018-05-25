defmodule Block.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Block.Repo, []),
      Block.S1,
      Block.S2
    ]
    opts = [strategy: :one_for_one, name: Block.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
