defmodule HitbWeb.BlockController do
  use HitbWeb, :controller
  alias Block
  alias Repos
  @moduledoc """
    Functionality related to blocks in the block chain
  """

  def add_block(conn, payload) do
    [conn, user] = HitbWeb.Login.user(conn)
    block = Block.BlockService.create_next_block(payload["data"], user.username)
    Block.BlockService.add_block(block)
    json(conn, %{})
  end

  def get_all_blocks(conn, _) do
    all_blocks =
      Repos.BlockRepository.get_all_blocks()
      |>Enum.map(fn x ->
          Map.put(x, :transactions, length(Repos.TransactionRepository.get_transactions_by_blockIndex(x.index)))
        end)
    json(conn,  %{blocks: all_blocks})
  end

  def getBlock(conn, %{"index" => index}) do
    block = Repos.BlockRepository.get_block(index)
    json(conn, %{block: block})
  end

  def getBlockByHash(conn, %{"hash" => hash}) do
    block = Repos.BlockRepository.get_block_by_hash(hash)
    json(conn, %{block: block})
  end

  def getFullBlock(conn, _) do
    json(conn, %{})
  end

  def getBlocks(conn, _) do
    json(conn, %{})
  end

  def getHeight(conn, _) do
    height = Repos.BlockRepository.get_all_blocks() |> List.last |> Map.get(:index)
    json(conn, %{height: height})
  end

  def getFee(conn, _) do
    json(conn, %{})
  end

  def getMilestone(conn, _) do
    json(conn, %{})
  end

  def getReward(conn, _) do
    json(conn, %{})
  end

  def getSupply(conn, _) do
    json(conn, %{})
  end

  def getStatus(conn, _) do
    json(conn, %{})
  end
end
