defmodule BlockWeb.P2pChannel do
  use Phoenix.Channel
  require Logger

  @query_latest_block Block.P2pMessage.query_latest_block
  @query_all_accounts Block.P2pMessage.query_all_accounts
  @query_all_blocks   Block.P2pMessage.query_all_blocks
  # @update_block_chain Block.P2pMessage.update_block_chain
  @add_peer_request   Block.P2pMessage.add_peer_request
  @query_all_transactions "query_all_transactions"
  @connection_error   Block.P2pMessage.connection_error
  @connection_success Block.P2pMessage.connection_success

  def join(_topic, _payload, socket) do
    IO.inspect IO.inspect "P2pChannel1"
    {:ok, socket}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end

  def handle_in(@query_latest_block, payload, socket) do
    Logger.info("sending latest block to #{inspect socket}")
    {:reply, {:ok, %{type: @query_latest_block, data: Block.BlockService.get_latest_block()}}, socket}
  end

  def handle_in(@query_all_accounts, payload, socket) do
    Logger.info("sending all accounts to #{inspect socket}")
    {:reply, {:ok, %{type: @query_all_accounts, data: Repos.AccountRepository.get_all_accounts()}}, socket}
  end

  def handle_in(@query_all_blocks, payload, socket) do
    Logger.info("sending all blocks to #{inspect socket}")
    {:reply, {:ok, %{type: @query_all_blocks, data: Repos.BlockRepository.get_all_blocks()}}, socket}
  end

  def handle_in(@query_all_transactions, payload, socket) do
    Logger.info("sending all transactions to #{inspect socket}")
    {:reply, {:ok, %{type: @query_all_transactions, data: Repos.TransactionRepository.get_all_transactions()}}, socket}
  end

  def handle_in(@add_peer_request, payload, socket) do
    Logger.info("attempting to connect to #{inspect payload}...")
    result = Peers.P2pSessionManager.connect(payload["host"], payload["port"])
    if result == :fail do
      {:reply, {:ok, %{type: @connection_error}}, socket}
    else
      {:reply, {:ok, %{type: @connection_success}}, socket}
    end
  end

  def handle_in(event, payload, socket) do
    Logger.warn("unhandled event #{event} #{inspect payload}")
    {:noreply, socket}
  end
end
