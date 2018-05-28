defmodule HitbserverWeb.ClientController do
  use HitbserverWeb, :controller
  plug HitbserverWeb.Access
  alias Stat.ClientService

  def stat_create(conn, %{"data" => data, "username" => username}) do
    result = ClientService.stat_create(data, username)
    json conn, result
  end

  def stat_client(conn, _params) do
    %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type, "username" => username, "rows" => rows} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc", "username" => "", "rows" => 13}, conn.params)
    result = ClientService.stat_client(page, page_type, type, tool_type, org, time, drg, order, order_type, username, rows)
    json conn, result
  end

  def stat_file(conn, _params) do
    %{"name" => name, "username" => username} = Map.merge(%{"name" => ""}, conn.params)
    result = ClientService.stat_file(name, username)
    json conn, result
  end

end
