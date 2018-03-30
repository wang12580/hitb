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
    user = get_session(conn, :user)
    login = HitbWeb.Login.is_login(conn)
    if(login)do
      render conn, "index.html"
    else
      redirect conn, to: "/login"
    end
    render conn, "index.html"
  end

  def status(conn, _params) do
    json(conn, %{})
  end

  def statusSync(conn, _params) do
    json(conn, %{})
  end

  def systemInfo(conn, _params) do
    json(conn, %{})
  end

  def block(conn, _params) do
    # json(conn, %{})
    render conn, "block.html"
  end

  def peer(conn, _params) do
    # json(conn, %{})
    render conn, "peers.html"
  end
  # 登录
  def login_html(conn, _params) do
    render conn, "login.html", layout: false
  end
end
