defmodule HitbWeb.AccountController do
  use HitbWeb, :controller
  alias Hitb
  @moduledoc """
    Functionality for managing peers
  """

  def openAccount(conn, _) do
    if(conn.params["username"])do
      [conn, user] = HitbWeb.Login.login(conn, %{username: conn.params["username"]})
      json(conn, %{login: true, user: user})
    else
      json(conn, %{login: false, user: %{}})
    end
  end

  def openAccount2(conn, _) do
    json(conn, %{})
  end

  def getBalance(conn, _) do
    json(conn, %{})
  end

  def getPublicKey(conn, _) do
    json(conn, %{})
  end

  def generatePublicKey(conn, _) do
    json(conn, %{})
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

  def getAccount(conn, _) do
    json(conn, %{})
  end

  def newAccount(conn, _) do
    # IO.inspect :crypto.hash(:sha256, "someone manual strong movie roof episode eight spatial brown soldier soup motor")
    # |> Base.encode64
    Repos.AccountRepository.insert_account()
    json(conn, %{})
  end

  def addSignature(conn, _) do
    json(conn, %{})
  end
end
