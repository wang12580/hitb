defmodule HitbWeb.Login do
  use HitbWeb, :controller

  #登录,返回conn

  #退出,返回conn
  def logout(conn) do
    put_session(conn, :user, %{login: false, username: nil})
  end

  def login(conn, user) do
    case Repos.AccountRepository.get_all_accounts() do
      [] ->
        account = %{index: 1, username: user.username,  u_username: "", isDelegate: 0, u_isDelegate:0, secondSignature: 0, u_secondSignature: 0, address: "1", publicKey: "1", secondPublicKey: "1", balance: 100000, u_balance: 0, vote: 0, rate: 0, delegates: "", u_delegates: "", multisignatures: "", u_multisignatures: "", multimin: 1, u_multimin: 1, multilifetime: 1, u_multilifetime: 1, blockId: "12", nameexist: true, u_nameexist: true, producedblocks: 1, missedblocks: 1, fees: 0, rewards: 1, lockHeight:  1}
        Repos.AccountRepository.insert_account(account)
        put_session(conn, :user, %{login: true, username: user.username})
      _ ->
      put_session(conn, :user, %{login: true, username: user.username})
    end
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
