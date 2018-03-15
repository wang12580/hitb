defmodule HitbWeb.PeerController do
  use HitbWeb, :controller
  @moduledoc """
    Functionality for managing peers
  """

  def add_peer(conn, peer_data) do
    host = peer_data["host"]
    port = peer_data["port"]
    result = Repos.P2pSessionManager.connect(host, port)
    if result == :fail do
      raise Repos.ErrorAlreadyConnected
    end
    json(conn, %{})
  end

  def get_all_peers(conn, _) do
    peers = :ets.tab2list(:peers)
      |> Enum.map(fn (peer_entry) ->
        peer_entry |> elem(1)
      end)
      json(conn,  %{peers: peers})
  end
end
