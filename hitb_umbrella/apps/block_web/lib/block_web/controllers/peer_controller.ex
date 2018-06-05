defmodule BlockWeb.PeerController do
  use BlockWeb, :controller
  plug BlockWeb.Access
  alias Hitb
  alias Block.PeerService
  alias Block.PeerRepository
  alias Block.P2pSessionManager
  alias Block.ErrorAlreadyConnected

  @moduledoc """
    Functionality for managing peers
  """

  def add_peer(conn, %{"peer_data" => peer_data}) do
    %{"host" => host, "port" => port} = peer_data
    result = P2pSessionManager.connect(host, port)
    if result != :ok do
      raise ErrorAlreadyConnected
    else
      PeerService.newPeer(host, port)
      json(conn, %{result: [host <> ":" <> port <> "节点连接成功"]})
    end
  end

  def get_all_peers(conn, _) do
    peers = PeerRepository.get_all_peers()
    peers = Enum.map(peers, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
    end)
    json(conn,  %{peers: peers})
  end

  def getPeers(conn, _) do
    json(conn, %{})
  end

  def getPeer(conn, _) do
    json(conn, %{})
  end

  def version(conn, _) do
    json(conn, %{})
  end
end
