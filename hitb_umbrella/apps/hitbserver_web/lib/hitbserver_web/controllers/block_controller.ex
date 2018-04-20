defmodule HitbserverWeb.BlockController do
  use HitbserverWeb, :controller
  alias HitbserverWeb.MyUser
  plug :put_layout, "app_blockchain.html"

  def blockchain(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "blockchain.html", user: user
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def bc_asset(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "bc_asset.html", user: user
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def bc_accounts(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "bc_accounts.html", user: user
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def bc_application(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "bc_application.html", user: user
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def bc_production(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "bc_production.html", user: user
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def bc_blockchain(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "bc_blockchain.html", user: user
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def bc_delegates(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "bc_delegates.html", user: user
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def bc_pay(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "bc_pay.html", user: user
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def bc_peers(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "bc_peers.html", user: user
    else
      redirect conn, to: "/hospitals/login"
    end
  end
end
