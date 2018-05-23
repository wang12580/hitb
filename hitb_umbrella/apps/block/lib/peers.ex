defmodule Peers do
  require Logger
  @moduledoc """
  Documentation for Peers.
  """
  def hello do
    :world
  end

  def getPublicIp do
    publicIp = nil
    publicIp
  end

  def newPeer(host, port)do
    peer = %{host: host, port: port, connect: true}
    Repos.PeerRepository.insert_peer(peer)
  end

end
