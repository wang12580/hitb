defmodule HitbserverWeb.Wt4Controller do
  use HitbserverWeb, :controller
  import Ecto.Query, warn: false
  plug HitbserverWeb.Access
  alias Library.Wt4
  alias Library.Wt4Service

  def index(conn, _params) do
    %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
    result = Wt4Service.wt4(page)
    render(conn, "index.json", result)
  end

  def stat_wt4(conn, %{"time" => time, "org" => org, "drg" => drg}) do
    %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
    result = Wt4Service.stat_wt4(time, org, drg, page)
    json conn, result
  end

end
