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
    children = [
      supervisor(Hitb.Repo, [])
    ]
    opts = [strategy: :one_for_one, name: Hitb.Supervisor]
    supervisor = Supervisor.start_link(children, opts)
    if(Hitb.Repo.all(Hitb.Server.User) == [])do
       %Hitb.Server.User{}
       |> Hitb.Server.User.changeset(%{age: 0, email: "admin@hitb.com", hashpw: "$2b$12$SD0aJYHV.VKrFYLl9IzXmOGCsyDajMCHcEVOwQOLi4o/XK9pbgIsu", name: "管理员", org: "系统管理员", tel: "00000000000", type: 1, username: "test@hitb.com.cn"})
       |> Hitb.Repo.insert
     end
    supervisor
  end
end
