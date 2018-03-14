defmodule HitbWeb.PageController do
  use HitbWeb, :controller
  alias Hitb
  alias Repos
  alias Peers
  alias Block
  alias Share
  alias Token

  def index(conn, _params) do
    Logger.info Hitb.hello()
    Logger.info Repos.hello()
    Logger.info Peers.hello()
    Logger.info Block.hello()
    Logger.info Share.hello()
    Logger.info Token.hello()
    render conn, "index.html"
  end
end
