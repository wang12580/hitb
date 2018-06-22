defmodule Block.Repo do
  use Ecto.Repo, otp_app: :block

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    init_peer(opts)
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  defp init_peer(config) do
    init_peer = %{
      host:  "139.129.165.56",
      port:  "4000",
      connect: true
    }
    database = config|>Enum.reject(fn x -> elem(x, 0) != :database end)|>List.first|>elem(1)
    :ets.new(:database, [:set, :public, :named_table])
    
    # if(database != "block_test")do
    #   Block.P2pSessionManager.connect(init_peer.host, init_peer.port)
    # end
    # peers = Block.PeerRepository.get_all_peers
    # if(peers != [])do
    #   peers |> Enum.each(fn x -> Block.P2pSessionManager.connect(x.host, x.port) end)
    # else
    #   case Block.P2pSessionManager.connect(init_peer.host, init_peer.port) do
    #     :ok ->
    #       Block.PeerRepository.insert_peer(init_peer)
    #     _ ->
    #       Block.PeerRepository.insert_peer(%{init_peer | :connect => false})
    #   end
    # end
  end
end
