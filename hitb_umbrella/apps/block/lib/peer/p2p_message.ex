defmodule Block.P2pMessage do
  @moduledoc """
  p2p messaging protocol. Defines message options.
  """
  @query_latest_block   "get_latest_block"
  @query_all_accounts     "get_all_accounts"
  @query_all_blocks     "get_all_blocks"
  @query_all_transactions "query_all_transactions"
  @update_block_chain   "update_block_chain"
  @add_peer_request     "add_peer_request"
  @already_connected    "already_connected"
  @connection_error     "connection_error"
  @connection_success   "successfully_connected"

  def query_latest_block,   do: @query_latest_block
  def query_all_accounts,     do: @query_all_accounts
  def query_all_blocks,     do: @query_all_blocks
  def query_all_transactions, do: @query_all_transactions
  def update_block_chain,   do: @update_block_chain
  def add_peer_request,     do: @add_peer_request
  def already_connected,    do: @already_connected
  def connection_error,     do: @connection_error
  def connection_success,   do: @connection_success
end
