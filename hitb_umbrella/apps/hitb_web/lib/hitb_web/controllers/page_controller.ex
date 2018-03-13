defmodule HitbWeb.PageController do
  use HitbWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
