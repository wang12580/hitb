defmodule HitbWeb.Login do
  use HitbWeb, :controller

  #登录,返回conn

  #退出,返回conn
  def logout(conn) do
    put_session(conn, :user, %{login: false, username: nil})
  end

  def login(conn, user) do
    case Repos.AccountRepository.get_account(user.username) do
      [] ->
        if user.username == "someone manual strong movie roof episode eight spatial brown soldier soup motor" and Repos.AccountRepository.get_all_accounts() === [] do
          Account.newAccount(user)
          user = Repos.AccountRepository.get_account(user.username)
          user =
            %{index: user.index,
              username: user.username,
              secret: user.username,
              balance: user.balance,
              publicKey: user.publicKey,
              blockId: user.blockId,
              delegates: user.delegates,
              lockHeight: user.lockHeight,
              address: user.address,
              secondPublicKey: user.secondPublicKey,
              vote: user.vote}
          [put_session(conn, :user, %{login: true, username: user.username}), %{user: user}]
        else
          [put_session(conn, :user, %{login: false, username: user.username}), %{}]
        end
      _ ->
        user = Repos.AccountRepository.get_account(user.username)
        user =
          %{index: user.index,
            username: user.username,
            secret: user.username,
            balance: user.balance,
            publicKey: user.publicKey,
            blockId: user.blockId,
            delegates: user.delegates,
            lockHeight: user.lockHeight,
            address: user.address,
            secondPublicKey: user.secondPublicKey,
            vote: user.vote}
        [put_session(conn, :user, %{login: true, username: user.username}), user]
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
