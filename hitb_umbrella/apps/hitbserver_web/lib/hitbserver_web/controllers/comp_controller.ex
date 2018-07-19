defmodule HitbserverWeb.CompController do
  use HitbserverWeb, :controller
  plug HitbserverWeb.Access
  # alias Stat.Key
  alias Stat.CompService

  def target1(conn, _params)do
    json conn, %{list: CompService.target1()}
  end

  def target(conn, %{"file" => file}) do
    result = CompService.target(file)
    json conn, result
  end
  def target_key(conn, %{"file" => file, "username" => username}) do
    result = CompService.target_key(file, username)
    json conn, result
  end
end
