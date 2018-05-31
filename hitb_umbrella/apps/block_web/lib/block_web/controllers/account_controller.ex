defmodule BlockWeb.AccountController do
  use BlockWeb, :controller
  plug BlockWeb.Access
  alias Hitb
  alias Block.AccountService
  @moduledoc """
    Functionality for managing peers
  """

  def openAccount(conn, _) do
    if(conn.params["username"])do
      [conn, user] = BlockWeb.Login.login(conn, %{username: conn.params["username"]})
      json(conn, %{login: true, user: user})
    else
      json(conn, %{login: false, user: %{}})
    end
  end

  def openAccount2(conn, _) do
    json(conn, %{})
  end

  def getBalance(conn, _) do
    user =
       case get_session(conn, :user) do
         nil -> %{login: false}
          _ -> get_session(conn, :user)
       end
    if(user.login)do
      balance = AccountService.getBalance(user.username)
      u_Balance = AccountService.getuBalance(user.username)
      json(conn, %{balance: balance, u_Balance: u_Balance})
    else
      json(conn, %{balance: 0, u_Balance: 0})
    end
  end

  def getPublicKey(conn, _) do
    user =
       case get_session(conn, :user) do
         nil -> %{login: false}
          _ -> get_session(conn, :user)
       end
    if(user.login)do
      json(conn, %{publicKey: user.publicKey})
    else
      json(conn, %{publicKey: ""})
    end
  end

  def generatePublicKey(conn, %{"username" => username}) do
    publicKey = AccountService.generatePublickey(username)
    json(conn, %{publicKey: publicKey})
  end

  def getDelegates(conn, _) do
    json(conn, %{})
  end

  def getDelegatesFee(conn, _) do
    json(conn, %{})
  end

  def addDelegates(conn, _) do
    json(conn, %{})
  end

  def getAccount(conn, %{"username" => username}) do
    account = Map.drop(Block.AccountRepository.get_account(username), [:__meta__, :__struct__])
    json(conn, %{account: account})
  end

  def getAccountByPublicKey(conn, %{"publicKey" => publicKey}) do
    account = Block.AccountRepository.get_account_by_publicKey(publicKey)
    json(conn, %{account: account})
  end

  def getAccountByAddress(conn, %{"address" => address}) do
    account = Block.AccountRepository.get_account_by_address(address)
    json(conn, %{account: account})
  end

  def newAccount(conn, %{"username" => username}) do
    case username do
      "" -> json(conn, %{success: false, user: %{username: username}, info: "用户名未填写"})
      _ ->
        account = AccountService.newAccount(%{username: username, balance: 0})
        case account do
          false ->
            json(conn, %{success: false, user: %{username: username}, info: "用户名重复"})
          _ ->
            user = Block.AccountRepository.get_account(username)
            json(conn, %{success: true, user: user, info: "用户创建成功"})
        end
    end
  end

  def addSignature(conn, %{"username" => username, "password" => password}) do
    [success, id] = AccountService.addSignature(username, password)
    [conn, _] = BlockWeb.Login.user(conn)
    json(conn, %{success:  success, transaction: id})
  end

  def getAccountsPublicKey(conn, _params) do
    [conn, user] = BlockWeb.Login.user(conn)
    publicKeys = Block.AccountRepository.get_all_accounts() |> Enum.map(fn x -> x.publicKey end) |> List.delete(user.publicKey)
    json conn, %{publicKeys: publicKeys}
  end
end
