defmodule Hitb.Application do
  @moduledoc """
  The Hitb Application Service.

  The hitb system business domain lives in this application.

  Exposes API to clients such as the `HitbWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Hitb.ets_new()
    children = []
    opts = [strategy: :one_for_one, name: Hitb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
