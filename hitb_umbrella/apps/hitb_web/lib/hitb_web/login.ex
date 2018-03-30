defmodule HitbWeb.Login do
  use HitbWeb, :controller

  #登录,返回conn

  #退出,返回conn
  def logout(conn) do
    put_session(conn, :user, %{login: false, username: nil})
  end

  def login(conn, user) do
    put_session(conn, :user, %{login: true, username: user.username})
  end

  #登录状态,返回是否登录
  def is_login(conn) do
    user = get_session(conn, :user)
    case user do
      nil -> false
      _ -> user.login
    end
  end

end
