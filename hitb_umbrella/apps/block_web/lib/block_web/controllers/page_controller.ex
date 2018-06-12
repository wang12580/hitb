defmodule BlockWeb.PageController do
  use BlockWeb, :controller
  plug BlockWeb.Access
  alias Hitb
  alias Repos
  alias Peers
  alias Block
  alias Share
  alias Token
  alias BlockWeb.Login
  import Ecto.Query

  def index(conn, _params) do
    login = Login.is_login(conn)
    if(login)do
      [conn, user] = Login.user(conn)
      render conn, "index.html", user: user
    else
      redirect conn, to: "/block/login"
    end
  end

  def test(conn, _params) do
    Block.Repo.all(from p in Block.Edit.Cda)
    |>Enum.each(fn x ->
        changeset = Block.Edit.CdaFile.changeset(%Block.Edit.CdaFile{}, %{username: x.username, filename: x.name})
        Block.Repo.insert(changeset)


    end)
    json conn, %{}
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
    login = Login.is_login(conn)
    if(login)do
      [conn, user] = Login.user(conn)
      render conn, "block.html", user: user, page: page
    else
      redirect conn, to: "/block/login"
    end
  end

  def peer(conn, _params) do
    login = Login.is_login(conn)
    if(login)do
      [conn, user] = Login.user(conn)
      render conn, "peers.html", user: user
    else
      redirect conn, to: "/block/login"
    end
  end
  # 登录
  def login_html(conn, _params) do
    render conn, "login.html", layout: false
  end
  # 用户信息
  def account(conn,  _params) do
    %{"page" => page} = Map.merge(%{ "page" => "" }, conn.params)
    login = Login.is_login(conn)
    if(login)do
      [conn, user] = Login.user(conn)
      render conn, "account.html", user: user, page: page
    else
      redirect conn, to: "/block/login"
    end
    # render conn, "account.html"
  end

  def logout(conn, _params) do
    conn = Login.logout(conn)
    redirect conn, to: "/block/login"
  end
end
