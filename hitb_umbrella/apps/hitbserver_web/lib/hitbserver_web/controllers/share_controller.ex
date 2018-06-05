defmodule HitbserverWeb.ShareController do
  use HitbserverWeb, :controller

  alias Server.ShareService
  plug HitbserverWeb.Access

  def share(conn, %{"username" => username, "type" => type, "file_name" => file_name}) do
    %{"content" => content} = Map.merge(%{"content" => []}, conn.params)
    result = ShareService.share(type, file_name, username, content)
    json conn, %{result: true}
  end

  def get_share(conn, _) do
    result = ShareService.get_share
    json conn, result
  end

  def insert_share(conn, %{"table" => table}) do
    ShareService.insert(table)
    json conn, %{result: true}
  end
end
