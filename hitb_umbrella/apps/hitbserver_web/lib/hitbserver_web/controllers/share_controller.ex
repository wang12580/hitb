defmodule HitbserverWeb.ShareController do
  use HitbserverWeb, :controller

  alias Server.ShareService
  plug HitbserverWeb.Access

  def share(conn, %{"username" => username, "type" => type, "file_name" => file_name, "content" => content}) do
    result = ShareService.share(type, file_name, username, content)
    json conn, result
  end
end
