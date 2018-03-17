defmodule HitbWeb.AccountController do
  use HitbWeb, :controller
  alias Hitb
  @moduledoc """
    Functionality for managing peers
  """

  def openAccount(conn, _) do
    json(conn, %{})
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
    json(conn, %{})
  end

  def addSignature(conn, _) do
    json(conn, %{})
  end
end
