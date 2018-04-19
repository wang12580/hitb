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
    login = HitbWeb.Login.is_login(conn)
    if(login)do
      IO.inspect :ets.tab2list(:peers)
      peer = :ets.tab2list(:peers) |> Enum.at(0)
      pid = peer |> elem(0)
      IO.inspect pid
      # # # IO.inspect Peers.P2pMessage.query_latest_block
      # # # IO.inspect Peers.P2pSessionManager.broadcast("ssss")
      transport = %{
        serializer: Phoenix.Channels.GenSocketClient.Serializer.Json,
        transport_mod: Phoenix.Channels.GenSocketClient.Transport.WebSocketClient,
        transport_pid: pid
      }
      # # IO.inspect "-----------PageController----------------"
      # # # IO.inspect peer
      # # IO.inspect "-----------PageController----------------"
      IO.inspect Phoenix.Channels.GenSocketClient.join(transport, "p2p", :ok)
      # # IO.inspect Phoenix.Channels.GenSocketClient.join(transport, "get_latest_block")
      # # IO.inspect "-----------PageController----------------"
      # IO.inspect Phoenix.Channels.GenSocketClient.push(transport, "p2p", "p2p", %{})
      # IO.inspect "-----------PageController----------------"
      [conn, user] = HitbWeb.Login.user(conn)
      render conn, "index.html", user: user
    else
      redirect conn, to: "/login"
    end
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
    %{"page" => page} = Map.merge(%{ "page" => "" }, conn.params)
    login = HitbWeb.Login.is_login(conn)
    if(login)do
      [conn, user] = HitbWeb.Login.user(conn)
      render conn, "block.html", user: user, page: page
    else
      redirect conn, to: "/login"
    end
  end

  def peer(conn, _params) do
    login = HitbWeb.Login.is_login(conn)
    if(login)do
      [conn, user] = HitbWeb.Login.user(conn)
      render conn, "peers.html", user: user
    else
      redirect conn, to: "/login"
    end
  end
  # 登录
  def login_html(conn, _params) do
    render conn, "login.html", layout: false
  end
  # 用户信息
  def account(conn,  _params) do
    %{"page" => page} = Map.merge(%{ "page" => "" }, conn.params)
    login = HitbWeb.Login.is_login(conn)
    if(login)do
      [conn, user] = HitbWeb.Login.user(conn)
      render conn, "account.html", user: user, page: page
    else
      redirect conn, to: "/login"
    end
    # render conn, "account.html"
  end

  def logout(conn, _params) do
    conn = HitbWeb.Login.logout(conn)
    redirect conn, to: "/login"
  end
end
