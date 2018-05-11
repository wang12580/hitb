defmodule ServerWeb.MyUser do
  use ServerWeb, :controller
  alias Comeonin.Bcrypt
  alias Server.User

  #登录,返回conn
  def login(conn, user, blockchain) do
    db_user = Repo.get_by(User, username: user.username)
    case db_user do
      nil ->
        {put_session(conn, :user, %{login: false, username: "", key: []}), false}
      _ ->
        case Bcrypt.checkpw(user.password, db_user.hashpw) do
          true ->
            #缓存区块链数据
            Hitbserver.ets_insert(:my_user, "blockchain" <> user.username, Map.merge(%{address2: ""}, blockchain))
            #缓存用户数据
            Hitbserver.ets_insert(:my_user, user.username, %{id: db_user.id, org: db_user.org, login: true, username: db_user.username, type: db_user.type, key: db_user.key, blockchain: blockchain})
            #返回登录
            {put_session(conn, :user, %{id: db_user.id, org: db_user.org, login: true, username: db_user.username, type: db_user.type, key: db_user.key, blockchain: blockchain, is_show: db_user.is_show}), true}
          _ -> {put_session(conn, :user, %{login: false, username: "", type: 2, key: []}), false}
        end
    end
  end

  #退出,返回conn
  def logout(conn) do
    put_session(conn, :user, %{login: false, username: nil})
  end

  #登录状态,返回是否登录
  def is_login(conn) do
    user = get_session(conn, :user)
    case user do
      nil -> false
      _ -> true
    end
  end

  #返回用户信息
  def user_info(conn) do
    user = get_session(conn, :user)
    cond do
      user == nil -> %{login: false, username: "", type: 2, key: []}
      user.username == nil ->  %{login: false, username: "", type: 2, key: []}
      true -> Repo.get_by(User, username: user.username)
    end
  end

  # defp user_blockchain(user, blockchain) do
  #   user = Map.merge(blockchain, user)
  #   #获取新的地址
  #   case HTTPoison.request(:post, "http://127.0.0.1:4096/api/accounts/open2/",
  #   Poison.encode!(%{publicKey: blockchain.publicKey}), [{"X-API-Key", "foobar"}, {"Content-Type", "application/json"}]) do
  #     {:ok, result} ->
  #       case Poison.decode!(result.body)["account"]["secondPublicKey"] do
  #         "" ->
  #           Map.merge(user, %{hassecond: false, address2: Poison.decode!(result.body)["account"]["address"]})
  #         _ -> Map.merge(user, %{hassecond: true, address2: Poison.decode!(result.body)["account"]["address"]})
  #       end
  #     {:error, _} ->
  #       Map.merge(user, %{hassecond: false, address2: ""})
  #   end
  # end

end
