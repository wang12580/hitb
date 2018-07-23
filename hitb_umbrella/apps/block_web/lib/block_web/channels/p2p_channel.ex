defmodule BlockWeb.P2pChannel do
  use Phoenix.Channel
  require Logger

  @query_latest_block Block.P2pMessage.query_latest_block
  @sync_block         Block.P2pMessage.sync_block
  @query_all_accounts Block.P2pMessage.query_all_accounts
  @query_all_blocks   Block.P2pMessage.query_all_blocks
  # @update_block_chain Block.P2pMessage.update_block_chain
  @add_peer_request   Block.P2pMessage.add_peer_request
  @query_all_transactions "query_all_transactions"
  alias Block.SyncService
  @connection_error   Block.P2pMessage.connection_error
  @connection_success Block.P2pMessage.connection_success
  alias Block.BlockService
  alias Block.AccountRepository
  alias Block.BlockRepository
  alias Block.TransactionRepository
  alias Block.P2pSessionManager
  # alias Block.PeerRepository

  def join(_topic, _payload, socket) do
    {:ok, socket}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end

  def handle_in(@sync_block, _payload, socket) do
    Logger.info("sync_block block")
    data = BlockService.get_latest_block()|>send()
    {:reply, {:ok, %{type: @sync_block, data: data}}, socket}
  end

  def handle_in(@query_latest_block, _payload, socket) do
    Logger.info("sending latest block")
    data = BlockService.get_latest_block()|>send()
    {:reply, {:ok, %{type: @query_latest_block, data: data}}, socket}
  end

  def handle_in(@query_all_accounts, _payload, socket) do
    Logger.info("sending all accounts")
    data = AccountRepository.get_all_accounts()|>Enum.map(fn x -> send(x) end)
    {:reply, {:ok, %{type: @query_all_accounts, data: data}}, socket}
  end

  def handle_in(@query_all_blocks, _payload, socket) do
    Logger.info("sending all blocks")
    data = BlockRepository.get_all_blocks()|>Enum.map(fn x -> send(x) end)
    {:reply, {:ok, %{type: @query_all_blocks, data: data}}, socket}
  end

  def handle_in(@query_all_transactions, _payload, socket) do
    Logger.info("sending all transactions")
    data = TransactionRepository.get_all_transactions()|>Enum.map(fn x -> send(x) end)
    {:reply, {:ok, %{type: @query_all_transactions, data: data}}, socket}
  end

  def handle_in("other_sync", payload, socket) do
    data =
      Map.keys(payload)
      |>Enum.reduce(%{}, fn x, acc ->
          data = SyncService.get_data(x, Map.get(payload, x))
          Map.put(acc, String.to_atom(x), data)
        end)
    {:reply, {:ok, %{type: "other_sync", data: data}}, socket}
  end

  # def handle_in("acto_sync", payload, socket) do
  #   PeerRepository.get_all_peers
  #   |> Enum.each(fn x -> Block.P2pSessionManager.connect(x.host, x.port) end)
  #   {:reply, {:ok, %{type: "acto_sync", data: []}}, socket}
  # end

  def handle_in(@add_peer_request, payload, socket) do
    Logger.info("attempting to connect...")
    result = P2pSessionManager.connect(payload["host"], payload["port"])
    if result != :ok do
      {:reply, {:ok, %{type: @connection_error}}, socket}
    else
      {:reply, {:ok, %{type: @connection_success}}, socket}
    end
  end

  def handle_in(event, payload, socket) do
    Logger.warn("unhandled event #{event} #{inspect payload}")
    {:noreply, socket}
  end

  defp send(map) do
    Map.drop(map, [:id, :__meta__, :__struct__])
  end

  # defp data(table, hash) do
  #   case hash do
  #     nil ->
  #       case table do
  #         "rulemdc_hash" -> OtherSyncService.get_rulemdc
  #         _ -> []
  #       end
  #     _ ->
  #       case table do
  #         "rulemdc_hash" -> OtherSyncService.get_rulemdc(hash)
  #         _ -> []
  #       end
  #   end
  # end
end
