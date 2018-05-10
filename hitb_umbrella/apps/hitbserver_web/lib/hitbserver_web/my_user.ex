defmodule HitbserverWeb.MyUser do
  use HitbserverWeb, :controller

  #登录,返回conn

  #退出,返回conn
  def logout(conn) do
    put_session(conn, :user, %{login: false, username: nil})
  end

  #登录状态,返回是否登录
  def is_login(conn) do
    user = get_session(conn, :user)
    case user do
      nil -> false
      _ ->
        # case blockchain do
          # nil -> false
          # _ ->
            user.login
        # end
    end
  end

  #返回用户信息
  def user_info(conn) do
    user = get_session(conn, :user)
    cond do
      user == nil -> %{login: false, username: "", type: 2, key: [], org: ""}
      user.username == nil ->  %{login: false, username: "", type: 2, key: [], org: ""}
      true ->
        db_user = Server.Repo.get_by(Server.User, username: user.username)
        %{username: user.username, type: 2, key: [], org: db_user.org}
        # case blockchain do
          # nil ->
            # %{login: false, username: "", type: 2, key: []}
          # _ ->
            # Map.merge(%{username: user.username}, %{publicKey: blockchain.publicKey, privateKey: blockchain.privateKey, address: blockchain.address})
        # end
    end
  end

  #求当前页的skip值(当前页码,每页条数)
  def skip(page, num) do
    #定义每页条目数量
    # num = 15
    (elem(Integer.parse(page),0)-1)*num
  end
end
