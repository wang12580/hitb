defmodule Repos.Application do
  @moduledoc """
  The Repos Application Service.

  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    initialize_datastore()
    children = []
    opts = [strategy: :one_for_one, name: Repos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def initialize_datastore() do
    initialize_db()
    :ets.new(:peers, [:set, :public, :named_table])
    :ets.new(:latest_block, [:set, :public, :named_table])
    init_peer()
    generate_initial_block()
  end

  defp initialize_db() do
    :mnesia.start()
    case :mnesia.wait_for_tables([:block_chain], 5000) do
      {:timeout, _} ->
        node = Node.self()
        :mnesia.create_table(:block_chain, [
          attributes: [:index, :previous_hash, :timestamp, :data, :hash, :generateAdress],
          type: :set
        ])
        :mnesia.create_table(:account, [
          attributes: [:index, :username, :u_username, :isDelegate, :u_isDelegate, :secondSignature,
          :u_secondSignature, :address, :publicKey, :secondPublicKey, :balance, :u_balance, :vote,
          :rate, :delegates, :u_delegates, :multisignatures, :u_multisignatures, :multimin, :u_multimin,
          :multilifetime, :u_multilifetime, :blockId, :nameexist, :u_nameexist, :producedblocks,
          :missedblocks, :fees, :rewards, :lockHeight],
          type: :set
        ])
        :mnesia.create_table(:transaction, [
          attributes: [:id, :height, :blockId, :type, :timestamp, :datetime, :senderPublicKey, :requesterPublicKey,
          :senderId, :recipientId, :amount, :fee, :signature, :signSignature, :asset, :args, :message],
          type: :set
        ])
        :mnesia.create_table(:peer, [
          attributes: [:host, :port, :connect],
          type: :set
        ])
        :ok = :mnesia.wait_for_tables([:block_chain], 5000)
      _ ->
        :ok
    end
  end

  defp init_peer() do
    init_peer = %Repos.Peer{
      host:  "139.129.165.56",
      port:  "4000",
      connect: true
    }
    # case :mnesia.transaction(fn -> :mnesia.foldl(fn(r, a) -> [r | a] end, [], :peer) end) do
    #   {:atomic, []} ->
    #     Peers.P2pSessionManager.connect(init_peer.host, init_peer.port)
    #     case Peers.P2pSessionManager.connect(init_peer.host, init_peer.port) do
    #       :ok ->
    #         :mnesia.transaction(fn -> :mnesia.write({:peer, init_peer.host, init_peer.port, init_peer.connect}) end)
    #       _ -> :error
    #     end
    #   {:atomic, peers} ->
    #     # 连接所有存储的节点
    #     peers |> Enum.each(fn x -> Peers.P2pSessionManager.connect(elem(x, 1), elem(x, 2)) end)
    #   _ -> :error
    # end
  end

  defp generate_initial_block() do
    secret = "someone manual strong movie roof episode eight spatial brown soldier soup motor"
    init_block = %Repos.Block{
      index: 0,
      previous_hash: "0",
      timestamp: :os.system_time(:seconds),
      data: "foofizzbazz",
      hash: :crypto.hash(:sha256, "cool") |> Base.encode64 |> regex,
      generateAdress: :crypto.hash(:sha256, "#{secret}")|> Base.encode64 |> regex
    }
    secret = "someone manual strong movie roof episode eight spatial brown soldier soup motor"
    init_transaction = %Repos.Transaction{
      id: Transaction.generateId,
      height: init_block.index,
      blockId: to_string(init_block.index),
      type:                 3,
      timestamp:            init_block.timestamp,
      datetime:             Transaction.generateDateTime,
      senderPublicKey:      :crypto.hash(:sha256, "publicKey#{secret}")|> Base.encode64|> regex,
      requesterPublicKey:   "",
      senderId:             "",
      recipientId:          "SYSTEM",
      amount:               0,
      fee:                  0,
      signature:            "",
      signSignature:       "",
      asset:                %{},
      args:                 {},
      message:              "创世区块"
    }
    :mnesia.transaction(fn ->
      case :mnesia.read({:block_chain, 0}) do
        [] ->
          :mnesia.write({:block_chain,
            init_block.index,
            init_block.previous_hash,
            init_block.timestamp,
            init_block.data,
            init_block.hash,
            init_block.generateAdress})
            :ets.insert(:latest_block, {:latest, init_block})
          :mnesia.write({:transaction,
            init_transaction.id,
            init_transaction.height,
            init_transaction.blockId,
            init_transaction.type,
            init_transaction.timestamp,
            init_transaction.datetime,
            init_transaction.senderPublicKey,
            init_transaction.requesterPublicKey,
            init_transaction.senderId,
            init_transaction.recipientId,
            init_transaction.amount,
            init_transaction.fee,
            init_transaction.signature,
            init_transaction.signSignature,
            init_transaction.asset,
            init_transaction.args,
            init_transaction.message})
        _ ->
          :ok
      end
    end)
  end

  defp regex(s) do
    [~r/\+/, ~r/ /, ~r/\=/, ~r/\%/, ~r/\//, ~r/\#/, ~r/\$/, ~r/\~/, ~r/\'/, ~r/\@/, ~r/\*/, ~r/\-/]
    |> Enum.reduce(s, fn x, acc -> Regex.replace(x, acc, "") end)
  end
end
