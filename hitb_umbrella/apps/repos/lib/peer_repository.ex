defmodule Repos.PeerRepository do
  @moduledoc """
    Defines functionality for interacting with the block chain
    mnesia table
  """

  def insert_peer(peer) do
    {:atomic, _} = :mnesia.transaction(fn ->
      :mnesia.write({:peer,
        # peer.pid,
        peer.host,
        peer.port,
        peer.connect})
    end)
    :ok
  end

  def get_all_peers() do
    {:atomic, result} = :mnesia.transaction(fn ->
      :mnesia.foldl(fn(record, acc) ->
        [deserialize_block_from_peer(record) | acc]
      end, [], :peer)
    end)
    #按照index排序
    result
      |> Enum.sort(fn(a, b) -> a.index < b.index end)
  end

  def deserialize_block_from_peer(record) do
    %Repos.Peer{
      host:        elem(record, 1),
      port:        elem(record, 2),
      connect:     elem(record, 3)
    }
  end
end
