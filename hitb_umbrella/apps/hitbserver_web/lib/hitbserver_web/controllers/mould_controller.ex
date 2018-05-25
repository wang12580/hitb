defmodule HitbserverWeb.MouldController do
  use HitbserverWeb, :controller
  alias Edit.MouldService
  # alias Hitb.Time
  plug HitbserverWeb.Access

  def mould_list(conn, _params) do
    %{"username" => username} = Map.merge(%{"username" => ""}, conn.params)
    result = MouldService.mould_list(username)
    json conn, %{result: result, success: true}
  end

  def mould_file(conn, _params) do
    %{"username" => username, "name" => name} = Map.merge(%{"username" => "", "name" => ""}, conn.params)
    result =  MouldService.mould_file(username, name)
    json conn, %{result: result, success: true}
  end

end
