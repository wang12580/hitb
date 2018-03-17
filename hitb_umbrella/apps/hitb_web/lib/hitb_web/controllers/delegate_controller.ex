defmodule HitbWeb.DelegateController do
  use HitbWeb, :controller
  alias Block
  alias Repos
  @moduledoc """
    Functionality related to blocks in the block chain
  """

  def count(conn, _) do
    json(conn, %{})
  end

  def getVoters(conn, _) do
    json(conn, %{})
  end

  def getDelegate(conn, _) do
    json(conn, %{})
  end

  def getDelegates(conn, _) do
    json(conn, %{})
  end

  def getDelegateFee(conn, _) do
    json(conn, %{})
  end

  def getForgedByAccount(conn, _) do
    json(conn, %{})
  end

  def addDelegate(conn, _) do
    json(conn, %{})
  end
end
