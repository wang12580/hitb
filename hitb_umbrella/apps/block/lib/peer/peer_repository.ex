defmodule Block.PeerRepository do
  import Ecto.Query, warn: false
  alias Block.Repo
  alias Block.Peer

  def insert_peer(peer) do
    %Peer{}
    |> Peer.changeset(peer)
    |> Repo.insert
    :ok
  end

  def get_all_peers() do
    Repo.all(from p in Peer)
  end
end
