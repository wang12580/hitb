defmodule Hitbserver.Application do
  @moduledoc """
  The Hitbserver Application Service.

  The hitbserver system business domain lives in this application.

  Exposes API to clients such as the `HitbserverWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Hitbserver.ets_new()
    Supervisor.start_link([], strategy: :one_for_one, name: Hitbserver.Supervisor)
  end
end
